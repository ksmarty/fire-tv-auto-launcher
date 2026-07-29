#!/bin/sh
set -e

if [ -z "$FIRE_IP" ]; then
  echo "Error: FIRE_IP environment variable is not set."
  echo "  Set it to your Fire TV Stick's IP address (e.g., 192.168.1.50)."
  exit 1
fi

LOG_FILE="/var/log/wolf_launcher.log"
ADB_PATH=$(which adb)

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a "$LOG_FILE"
}

wait_for_authorization() {
  log "Waiting for ADB authorization on Fire TV..."
  log ">>> Look at your Fire TV and select 'Allow' if prompted <<<"

  while true; do
    $ADB_PATH connect "$FIRE_IP" >/dev/null 2>&1
    STATUS=$($ADB_PATH get-state "$FIRE_IP" 2>/dev/null || true)

    case "$STATUS" in
      device)
        log "Device authorized"
        return 0
        ;;
      unauthorized)
        log "Waiting for you to approve on Fire TV..."
        sleep 5
        ;;
      *)
        sleep 10
        ;;
    esac
  done
}

log "Starting Wolf Launcher monitor (target: $FIRE_IP)"
wait_for_authorization

while true; do
  $ADB_PATH connect "$FIRE_IP" >/dev/null 2>&1

  CURRENT_APP=$($ADB_PATH shell dumpsys activity activities 2>/dev/null | grep -i mResumedActivity || true)

  if echo "$CURRENT_APP" | grep -q "com.amazon.tv.launcher"; then
    log "Amazon launcher detected — launching Wolf Launcher"
    $ADB_PATH shell am start -n com.wolf.firelauncher/.screens.launcher.LauncherActivity >> "$LOG_FILE" 2>&1
  fi

  sleep 60
done
