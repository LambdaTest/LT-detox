#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./_nvm.sh
. "$SCRIPT_DIR/_nvm.sh"

echo "✅ Using Node: $(node -v) from $(command -v node)"
echo "✅ Using Xcode: $(xcodebuild -version)"

# Attach Detox to HyperExecute's already-booted (video-recorded) simulator.
if [ -z "${DETOX_SIM_UDID:-}" ]; then
  _SIMCTL_JSON=$(xcrun simctl list devices booted -j)
  if command -v jq >/dev/null 2>&1; then
    DETOX_SIM_UDID=$(printf '%s' "$_SIMCTL_JSON" | jq -r '[.devices[][].udid] | first // empty')
  else
    DETOX_SIM_UDID=$(printf '%s' "$_SIMCTL_JSON" | python3 -c 'import json,sys; d=json.load(sys.stdin); ids=[dev["udid"] for runtime in d.get("devices",{}).values() for dev in runtime]; print(ids[0] if ids else "")')
  fi
  export DETOX_SIM_UDID
  unset _SIMCTL_JSON
fi
if [ -n "${DETOX_SIM_UDID:-}" ]; then
  echo "✅ Using booted simulator UDID=$DETOX_SIM_UDID"
else
  echo "⚠️ No booted simulator found; Detox will boot from detox.config.js device type"
fi

if [ -z "${1:-}" ]; then
  echo "usage: execute.sh <npm-script>" >&2
  exit 1
fi

npm run "$1"
