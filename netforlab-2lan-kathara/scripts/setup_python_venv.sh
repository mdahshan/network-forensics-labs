#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${1:-$SCRIPT_DIR/.venv}"
REQUIREMENTS_FILE="$SCRIPT_DIR/requirements-diagram.txt"

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is not installed. Run scripts/install_lab_dependencies.sh first." >&2
  exit 1
fi

if [[ ! -f "$REQUIREMENTS_FILE" ]]; then
  echo "Missing requirements file: $REQUIREMENTS_FILE" >&2
  exit 1
fi

echo "Creating virtual environment at: $VENV_DIR"
python3 -m venv "$VENV_DIR"

# shellcheck source=/dev/null
source "$VENV_DIR/bin/activate"

python -m pip install --upgrade pip
python -m pip install -r "$REQUIREMENTS_FILE"

echo
echo "Virtual environment ready."
echo "Activate it with: source $VENV_DIR/bin/activate"
