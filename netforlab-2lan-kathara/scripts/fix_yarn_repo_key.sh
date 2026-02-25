#!/usr/bin/env bash
set -euo pipefail

# Fixes missing Yarn APT signing key (NO_PUBKEY 62D54FD4003F6525)
# in Debian/Ubuntu environments.
#
# This script uses the current keyring-based method and updates
# the keyring file used by sources that specify:
#   signed-by=/usr/share/keyrings/yarn-archive-keyring.gpg

KEY_ID="62D54FD4003F6525"
KEYRING_PATH="/usr/share/keyrings/yarn-archive-keyring.gpg"

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required." >&2
  exit 1
fi

if ! command -v gpg >/dev/null 2>&1; then
  echo "gpg is required." >&2
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required." >&2
  exit 1
fi

echo "[1/3] Fetching Yarn public key and writing keyring..."
sudo mkdir -p /usr/share/keyrings
curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee "$KEYRING_PATH" >/dev/null

echo "[2/3] Verifying key fingerprint contains $KEY_ID..."
if ! gpg --show-keys --with-colons "$KEYRING_PATH" | grep -qi "$KEY_ID"; then
  echo "Expected key $KEY_ID not found in $KEYRING_PATH" >&2
  exit 1
fi

echo "[3/3] Running apt-get update..."
sudo apt-get update

echo "Yarn repository key update completed successfully."
