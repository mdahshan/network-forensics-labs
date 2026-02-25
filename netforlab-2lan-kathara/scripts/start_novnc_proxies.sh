#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/tmp/netforlab-novnc"
PID_PC2="$BASE_DIR/pc2.pid"
PID_PC3="$BASE_DIR/pc3.pid"
LOG_PC2="$BASE_DIR/pc2.log"
LOG_PC3="$BASE_DIR/pc3.log"

PC2_VNC_TARGET="localhost:5922"
PC3_VNC_TARGET="localhost:5923"
PC2_WEB_PORT="6082"
PC3_WEB_PORT="6083"

NOVNC_WEB_DIR="/usr/share/novnc"

mkdir -p "$BASE_DIR"

require_dependencies() {
  if ! command -v websockify >/dev/null 2>&1; then
    echo "Missing dependency: websockify" >&2
    echo "Run ./scripts/install_lab_dependencies.sh first." >&2
    exit 1
  fi

  if [[ ! -d "$NOVNC_WEB_DIR" ]]; then
    echo "Missing dependency: novnc web assets at $NOVNC_WEB_DIR" >&2
    echo "Run ./scripts/install_lab_dependencies.sh first." >&2
    exit 1
  fi
}

is_running() {
  local pid_file="$1"
  if [[ -f "$pid_file" ]]; then
    local pid
    pid="$(cat "$pid_file")"
    if [[ -n "$pid" ]] && kill -0 "$pid" >/dev/null 2>&1; then
      return 0
    fi
  fi
  return 1
}

start_one() {
  local name="$1"
  local web_port="$2"
  local vnc_target="$3"
  local pid_file="$4"
  local log_file="$5"

  if is_running "$pid_file"; then
    echo "$name proxy already running (PID $(cat "$pid_file"))."
    return
  fi

  nohup websockify --web "$NOVNC_WEB_DIR" "$web_port" "$vnc_target" >"$log_file" 2>&1 &
  echo $! >"$pid_file"
  echo "Started $name proxy: http://localhost:${web_port}/vnc.html?host=localhost&port=${web_port}"
}

stop_one() {
  local name="$1"
  local pid_file="$2"

  if ! is_running "$pid_file"; then
    rm -f "$pid_file"
    echo "$name proxy is not running."
    return
  fi

  local pid
  pid="$(cat "$pid_file")"
  kill "$pid"
  rm -f "$pid_file"
  echo "Stopped $name proxy (PID $pid)."
}

status_one() {
  local name="$1"
  local web_port="$2"
  local pid_file="$3"

  if is_running "$pid_file"; then
    echo "$name: running (PID $(cat "$pid_file")) -> http://localhost:${web_port}/vnc.html?host=localhost&port=${web_port}"
  else
    echo "$name: stopped"
  fi
}

usage() {
  cat <<'EOF'
Usage: ./scripts/start_novnc_proxies.sh [start|stop|restart|status]

  start   Start noVNC proxies for pc2 and pc3
  stop    Stop noVNC proxies for pc2 and pc3
  restart Restart noVNC proxies for pc2 and pc3
  status  Show current proxy status
EOF
}

ACTION="${1:-start}"

case "$ACTION" in
  start)
    require_dependencies
    start_one "pc2" "$PC2_WEB_PORT" "$PC2_VNC_TARGET" "$PID_PC2" "$LOG_PC2"
    start_one "pc3" "$PC3_WEB_PORT" "$PC3_VNC_TARGET" "$PID_PC3" "$LOG_PC3"
    ;;
  stop)
    stop_one "pc2" "$PID_PC2"
    stop_one "pc3" "$PID_PC3"
    ;;
  restart)
    "$0" stop
    "$0" start
    ;;
  status)
    status_one "pc2" "$PC2_WEB_PORT" "$PID_PC2"
    status_one "pc3" "$PC3_WEB_PORT" "$PID_PC3"
    ;;
  *)
    usage
    exit 1
    ;;
esac
