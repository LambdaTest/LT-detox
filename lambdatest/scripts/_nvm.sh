# Shared nvm bootstrap. Source this file; do not execute it.
# Pins nvm to a commit SHA (tags are mutable) and honours the repo-root .nvmrc.

NVM_COMMIT="977563e97ddc66facf3a8e31c6cff01d236f09bd"
NVM_TAG="v0.40.3"
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

_LT_NVM_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_LT_REPO_ROOT="$(cd "$_LT_NVM_SCRIPT_DIR/../.." && pwd)"

if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  git clone --branch "$NVM_TAG" --depth 1 https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  _LT_NVM_HEAD="$(git -C "$NVM_DIR" rev-parse HEAD)"
  if [ "$_LT_NVM_HEAD" != "$NVM_COMMIT" ]; then
    echo "Error: nvm SHA mismatch (expected $NVM_COMMIT, got $_LT_NVM_HEAD)" >&2
    exit 1
  fi
fi

# shellcheck source=/dev/null
. "$NVM_DIR/nvm.sh"
if [ -s "$NVM_DIR/bash_completion" ]; then
  # shellcheck source=/dev/null
  . "$NVM_DIR/bash_completion"
fi

# nvm install with no args reads .nvmrc from the current directory.
pushd "$_LT_REPO_ROOT" >/dev/null
nvm install
nvm use
popd >/dev/null
