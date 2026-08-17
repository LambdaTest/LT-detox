#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./_nvm.sh
. "$SCRIPT_DIR/_nvm.sh"

export ANDROID_HOME=/usr/lib/android-sdk

pwd
npm ci
