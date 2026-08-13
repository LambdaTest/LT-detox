#!/bin/bash

# Enable debugging for troubleshooting (optional)
set -e

# Step 1: Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# Step 2: Source nvm and configure the environment
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh" # Load nvm
else
    echo "Error: nvm.sh not found. Ensure nvm was installed correctly."
    exit 1
fi

if [ -s "$NVM_DIR/bash_completion" ]; then
    . "$NVM_DIR/bash_completion" # Load nvm bash completion (optional)
fi

# (Optional) Use Node version from .nvmrc if present
if [ -f ".nvmrc" ]; then
  nvm install
  nvm use
else
  nvm install 18
  nvm use 18
fi

# Keep node_modules, vendor/bundle, and ios/Pods so HyperExecute cache can be reused.
# Still wipe Xcode output; it is machine-specific and not cached.
rm -rf ios/build
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf ios/.xcode.env*

# Step 3: Set ruby 3.2.2 as global version
eval "$(rbenv init -)"
rbenv global 3.2.2

echo "verify ruby version"
ruby -v
export LANG=en_US.UTF-8

gem install bundler:2.6.8  
bundle install --path vendor/bundle

npm install
npm install --save-dev @react-native-community/cli

npm run podInstall:ios

echo "Current directory: $PWD"
ls -la "$PWD"

PROJECT_DIR="$PWD"
echo "Using project directory: $PROJECT_DIR"
cd "$PROJECT_DIR"
