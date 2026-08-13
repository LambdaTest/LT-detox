#!/bin/bash
# Enable debugging for troubleshooting
set -e

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Install and use Node.js
NODE_VERSION="18"
nvm use $NODE_VERSION
# Set NODE_BINARY for Xcode
NODE_BINARY=$(command -v node)
# Clean Xcode environment
unset XCODE_ENV_FILE
echo "export NODE_BINARY=$NODE_BINARY" | tee .xcode.env .xcode.env.local

echo "✅ Using Node: $(node -v) from $(which node)"
echo "✅ Using Xcode: $(xcodebuild -version)"
echo "✅ Enforcing NODE_BINARY=$NODE_BINARY"

# Attach Detox to HyperExecute's already-booted (video-recorded) simulator.
if [ -z "${DETOX_SIM_UDID:-}" ]; then
  DETOX_SIM_UDID=$(xcrun simctl list devices | awk -F '[()]' '/\(Booted\)/{print $2; exit}')
  export DETOX_SIM_UDID
fi
if [ -n "${DETOX_SIM_UDID:-}" ]; then
  echo "✅ Using booted simulator UDID=$DETOX_SIM_UDID"
else
  echo "⚠️ No booted simulator found; Detox will boot from detox.config.js device type"
fi

# Navigate to project directory
PROJECT_DIR="$PWD"
echo "Using project directory: $PROJECT_DIR"
cd "$PROJECT_DIR"

# Run the specified npm command
npm run $1
