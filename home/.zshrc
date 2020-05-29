#
# ~/.zshrc
#

_exists() {
  command -v $1 > /dev/null 2>&1
}

# ------------------------------------------------------------------------------
# Environment
# ------------------------------------------------------------------------------

# Export path to root of dotfiles repo
export DOTFILES=${DOTFILES:="$HOME/.dotfiles"}

# Source zplug manager (https://github.com/zplug/zplug)
source "$DOTFILES/modules/zplug/init.zsh"

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Do not override files using `>`, but it's still possible using `>!`
set -o noclobber

# Extend $PATH without duplicates
_extend_path() {
  if ! $( echo "$PATH" | tr ":" "\n" | grep -qx "$1" ) ; then
    export PATH="$1:$PATH"
  fi
}

# Add custom bin to $PATH
[[ -d "$HOME/.bin" ]] && _extend_path "$HOME/.bin"
[[ -d "$DOTFILES/bin" ]] && _extend_path "$DOTFILES/bin"
[[ -d "$HOME/.npm-global" ]] && _extend_path "$HOME/.npm-global/bin"
[[ -d "$HOME/.local/bin" ]] && _extend_path "$HOME/.local/bin"
[[ -d "$ZPLUG_BIN" ]] && _extend_path "$ZPLUG_BIN"

# Pyenv init
if _exists pyenv; then
  eval "$(pyenv init -)"
fi

# Extend $NODE_PATH
if [ -d ~/.npm-global ]; then
  export NODE_PATH="$NODE_PATH:$HOME/.npm-global/lib/node_modules"
fi

# Default pager
export PAGER='less'

# less options
less_opts=(
  # Quit if entire file fits on first screen.
  --quit-if-one-screen
  # Ignore case in searches that do not contain uppercase.
  --ignore-case
  # Allow ANSI colour escapes, but no other escapes.
  --RAW-CONTROL-CHARS
  # Quiet the terminal bell. (when trying to scroll past the end of the buffer)
  --quiet
  # Do not complain when we are on a dumb terminal.
  --dumb
)
export LESS="${less_opts[*]}"

# Default editor for local and remote sessions
if [[ -n "$SSH_CONNECTION" ]]; then
  # on the server
  if [ command -v vim >/dev/null 2>&1 ]; then
    export EDITOR='vim'
  else
    export EDITOR='vi'
  fi
else
  export EDITOR='vim'
fi

# SSH
export SSH_KEY_PATH="$HOME/.ssh/id_rsa"

# GPG
export GPG_TTY=$(tty)

# ------------------------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------------------------

# Let zplug manage itself like other packages
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Oh-My-Zsh core
zplug "lib/*", from:oh-my-zsh

# Oh-My-Zsh plugins
zplug "plugins/history-substring-search", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/ssh-agent", from:oh-my-zsh
zplug "plugins/gpg-agent", from:oh-my-zsh

# Zsh improvements
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "hlissner/zsh-autopair", defer:2

# Extra
zplug "denysdovhan/gitio-zsh", as:command, use:"gitio.zsh", rename-to:"gitio"
zplug "rauchg/wifi-password", as:command, use:"wifi-password.sh", rename-to:"wifi-password"
zplug "djui/alias-tips", defer:2

# Spaceship ZSH
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

# Dotfiles
zplug "$DOTFILES/lib", from:local

# Custom local overridings
zplug "$DOTFILES/custom", from:local

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load

ZSH_HIGHLIGHT_MAXLENGTH=200
