#!/usr/bin/env bash
set -euo pipefail

# Installs only missing host dependencies for this lab.
# Follows Kathara Linux (Debian-based) official installation flow:
# https://github.com/KatharaFramework/Kathara/wiki/Linux#debian-based
#
# Notes:
# - Kathara is installed from the official Kathara apt repository.
# - tmux is installed (if missing) so it can be used via CLI options.
# - Docker is NOT installed automatically unless INSTALL_DOCKER=1 is set,
#   to avoid conflicts in environments where Docker is already provided
#   (for example, the default Microsoft devcontainer image).

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This script currently supports Debian/Ubuntu systems (apt-get)." >&2
  exit 1
fi

if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
  SUDO=""
else
  if ! command -v sudo >/dev/null 2>&1; then
    echo "sudo is required to install system packages." >&2
    exit 1
  fi
  SUDO="sudo"
fi

source /etc/os-release
OS_ID="${ID:-}"
OS_VERSION_ID="${VERSION_ID:-}"

KATHARA_LIST_FILE="/etc/apt/sources.list.d/kathara.list"
KATHARA_KEYRING_FILE="/usr/share/keyrings/ppa-kathara-archive-keyring.gpg"

configure_kathara_repo() {
  if command -v kathara >/dev/null 2>&1 || dpkg -s kathara >/dev/null 2>&1; then
    return
  fi

  if [[ "$OS_ID" == "ubuntu" ]]; then
    if ! command -v add-apt-repository >/dev/null 2>&1; then
      echo "Installing missing package: software-properties-common"
      $SUDO apt-get update
      $SUDO apt-get install -y software-properties-common
    fi

    if [[ ! -f "$KATHARA_LIST_FILE" ]] || ! grep -q "katharaframework/kathara" "$KATHARA_LIST_FILE" 2>/dev/null; then
      echo "Adding Kathara PPA repository (Ubuntu)..."
      $SUDO add-apt-repository -y ppa:katharaframework/kathara
    fi
    return
  fi

  if [[ "$OS_ID" == "debian" || "$OS_ID" == "kali" ]]; then
    local ubuntu_suite
    case "$OS_VERSION_ID" in
      11) ubuntu_suite="focal" ;;
      12|13|"" ) ubuntu_suite="jammy" ;;
      *) ubuntu_suite="jammy" ;;
    esac

    if [[ ! -f "$KATHARA_KEYRING_FILE" ]]; then
      echo "Adding Kathara signing key..."
      $SUDO mkdir -p /usr/share/keyrings
      wget -qO - "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x21805a48e6cbba6b991abe76646193862b759810" \
        | $SUDO gpg --dearmor -o "$KATHARA_KEYRING_FILE"
    fi

    if [[ ! -f "$KATHARA_LIST_FILE" ]] || ! grep -q "katharaframework/kathara" "$KATHARA_LIST_FILE" 2>/dev/null; then
      echo "Adding Kathara apt repository (Debian-based, suite: $ubuntu_suite)..."
      {
        echo "deb [ signed-by=$KATHARA_KEYRING_FILE ] http://ppa.launchpad.net/katharaframework/kathara/ubuntu $ubuntu_suite main"
        echo "deb-src [ signed-by=$KATHARA_KEYRING_FILE ] http://ppa.launchpad.net/katharaframework/kathara/ubuntu $ubuntu_suite main"
      } | $SUDO tee "$KATHARA_LIST_FILE" >/dev/null
    fi
    return
  fi

  echo "Unsupported distro for this script: ${OS_ID:-unknown}" >&2
  echo "Use the Kathara pip installation guide for other distros:" >&2
  echo "https://github.com/KatharaFramework/Kathara/wiki/pip" >&2
  exit 1
}

APT_PACKAGES=()

if ! command -v python3 >/dev/null 2>&1; then
  APT_PACKAGES+=(python3)
fi

if ! python3 -m pip --version >/dev/null 2>&1; then
  APT_PACKAGES+=(python3-pip)
fi

if ! python3 -c "import venv" >/dev/null 2>&1; then
  APT_PACKAGES+=(python3-venv)
fi

if ! command -v tmux >/dev/null 2>&1; then
  APT_PACKAGES+=(tmux)
fi

if [[ ! -d /usr/share/novnc ]]; then
  APT_PACKAGES+=(novnc)
fi

if ! command -v websockify >/dev/null 2>&1; then
  APT_PACKAGES+=(websockify)
fi

if command -v docker >/dev/null 2>&1; then
  echo "Docker already installed. Skipping Docker package install."
elif [[ "${INSTALL_DOCKER:-0}" == "1" ]]; then
  echo "Docker not found; INSTALL_DOCKER=1 set, scheduling docker.io install."
  APT_PACKAGES+=(docker.io)
else
  echo "Docker not found. Skipping Docker installation to avoid conflicts."
  echo "Set INSTALL_DOCKER=1 if you explicitly want this script to install docker.io."
fi

if ! command -v wget >/dev/null 2>&1; then
  APT_PACKAGES+=(wget)
fi

if ! command -v gpg >/dev/null 2>&1; then
  APT_PACKAGES+=(gnupg)
fi

if (( ${#APT_PACKAGES[@]} > 0 )); then
  echo "[1/3] Installing missing system packages: ${APT_PACKAGES[*]}"
  $SUDO apt-get update
  $SUDO apt-get install -y "${APT_PACKAGES[@]}"
else
  echo "[1/3] Required system packages already installed."
fi

echo "[2/3] Installing Kathara from official apt repository..."
if command -v kathara >/dev/null 2>&1 || dpkg -s kathara >/dev/null 2>&1; then
  if command -v kathara >/dev/null 2>&1; then
    echo "Kathara already installed at: $(command -v kathara)"
  else
    echo "Kathara package already installed."
  fi
else
  configure_kathara_repo
  $SUDO apt-get update
  $SUDO apt-get install -y kathara
fi

echo "[3/3] Verifying installations..."
if command -v kathara >/dev/null 2>&1; then
  echo "Kathara available at: $(command -v kathara)"
else
  echo "Kathara installation failed." >&2
  exit 1
fi

if command -v tmux >/dev/null 2>&1; then
  echo "tmux available at: $(command -v tmux)"
else
  echo "tmux installation failed." >&2
  exit 1
fi

echo
echo "Done."
echo "Next steps:"
echo "  1) Start lab with tmux terminal option: kathara lstart --terminal-emu TMUX"
echo "  2) Ensure Docker daemon is running."
echo "  3) (Optional) Add your user to docker group: sudo usermod -aG docker $USER"
echo "  4) Re-login after docker group changes."
