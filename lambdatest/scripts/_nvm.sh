# Shared nvm bootstrap. Source this file; do not execute it.
# Pins nvm to a commit SHA (tags are mutable) and honours the repo-root .nvmrc.

NVM_COMMIT="977563e97ddc66facf3a8e31c6cff01d236f09bd"
NVM_INSTALL_SH="https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_COMMIT}/install.sh"

_LT_NVM_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_LT_REPO_ROOT="$(cd "$_LT_NVM_SCRIPT_DIR/../.." && pwd)"

_lt_nvm_is_usable_dir() {
  local dir="$1"
  case "$dir" in
    /etc/skel|/etc/skel/*)
      return 1
      ;;
  esac
  local parent
  parent="$(dirname "$dir")"
  [ -w "$parent" ] || return 1
  if [ -e "$dir" ] && [ ! -w "$dir" ]; then
    return 1
  fi
  return 0
}

if [ -n "${NVM_DIR:-}" ] && _lt_nvm_is_usable_dir "$NVM_DIR"; then
  :
elif _lt_nvm_is_usable_dir "${HOME}/.nvm"; then
  export NVM_DIR="${HOME}/.nvm"
else
  export NVM_DIR="${_LT_REPO_ROOT}/.nvm"
fi

echo "nvm install dir: $NVM_DIR"

_lt_nvm_head() {
  git -C "$NVM_DIR" rev-parse HEAD 2>/dev/null || true
}


if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  echo "Installing nvm from ${NVM_COMMIT}"
  mkdir -p "$NVM_DIR"
  curl -fsSL "$NVM_INSTALL_SH" | bash
fi

if [ -d "$NVM_DIR/.git" ] && [ "$(_lt_nvm_head)" != "$NVM_COMMIT" ]; then
  git -C "$NVM_DIR" -c advice.detachedHead=false fetch --depth 1 origin "$NVM_COMMIT"
  git -C "$NVM_DIR" -c advice.detachedHead=false checkout --quiet "$NVM_COMMIT"
  if [ "$(_lt_nvm_head)" != "$NVM_COMMIT" ]; then
    echo "Error: nvm SHA mismatch (expected $NVM_COMMIT, got $(_lt_nvm_head))" >&2
    exit 1
  fi
fi

if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  echo "Error: nvm.sh not found in $NVM_DIR" >&2
  exit 1
fi

# nvm.sh is not safe with nounset; keep errexit off while it loads and installs.
_lt_nvm_errexit=0
_lt_nvm_nounset=0
case $- in *e*) _lt_nvm_errexit=1 ;; esac
case $- in *u*) _lt_nvm_nounset=1 ;; esac
set +eu

# shellcheck source=/dev/null
. "$NVM_DIR/nvm.sh"

# Honour .nvmrc from the repo root. Keep npm's download cache in-tree so
# HyperExecute can restore it (npm ci always rebuilds node_modules).
export npm_config_cache="${_LT_REPO_ROOT}/.npm"
pushd "$_LT_REPO_ROOT" >/dev/null
echo "Installing Node $(tr -d '[:space:]' < "${_LT_REPO_ROOT}/.nvmrc")"
nvm install
nvm use
popd >/dev/null

if [ "$_lt_nvm_errexit" -eq 1 ]; then
  set -e
fi
if [ "$_lt_nvm_nounset" -eq 1 ]; then
  set -u
fi
unset _lt_nvm_errexit _lt_nvm_nounset
