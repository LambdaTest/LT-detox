#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./_nvm.sh
. "$SCRIPT_DIR/_nvm.sh"

# Keep node_modules, vendor/bundle, and ios/Pods so HyperExecute cache can be reused.
# Detox isolates Xcode output via -derivedDataPath ios/build; do not wipe the
# user-global DerivedData directory (that would force a cold build every run).
rm -rf ios/build

eval "$(rbenv init -)"
rbenv install -s 3.2.2
rbenv local 3.2.2

echo "verify ruby version"
ruby -v
export LANG=en_US.UTF-8

gem install bundler:2.6.8
bundle config set --local path vendor/bundle
bundle install

npm ci
npm run podInstall:ios

echo "Current directory: $PWD"
ls -la "$PWD"
