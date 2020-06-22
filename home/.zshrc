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

# Source zinit manager (https://github.com/zdharma/zinit)
source "$DOTFILES/modules/zinit/zinit.zsh"

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

# Pyenv init
if _exists pyenv; then
  eval "$(pyenv init -)"
fi

# Go env
if _exists go; then
  export GOPATH="$HOME/.go"
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
  -FX
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

# Some fixes
ZSH_HIGHLIGHT_MAXLENGTH=200

# ------------------------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------------------------

# Oh-My-Zsh core
# Unfortunately, zinit doesn't work with "*.zsh" for OMZ libs :\
zinit for \
    OMZL::clipboard.zsh \
    OMZL::compfix.zsh \
    OMZL::completion.zsh \
    OMZL::directories.zsh \
    OMZL::functions.zsh \
    OMZL::git.zsh \
    OMZL::grep.zsh \
    OMZL::history.zsh \
    OMZL::key-bindings.zsh \
    OMZL::misc.zsh \
    OMZL::termsupport.zsh \
    OMZL::theme-and-appearance.zsh

# Oh-My-Zsh plugins
zinit wait lucid for \
    OMZP::git \
    OMZP::sudo \
    OMZP::extract \
    OMZP::ssh-agent \
    OMZP::gpg-agent \

# Zsh improvements
zinit for \
    light-mode zsh-users/zsh-autosuggestions \
    light-mode zsh-users/zsh-syntax-highlighting \
    light-mode zsh-users/zsh-history-substring-search \
    light-mode hlissner/zsh-autopair

# Extra
zinit ice as"command" mv"wifi-password.sh -> wifi-password"
zinit light rauchg/wifi-password

zinit wait lucid for \
    light-mode djui/alias-tips

# Spaceship ZSH
zinit light denysdovhan/spaceship-prompt

# Dotfiles
zinit load "$DOTFILES/lib"

# Custom local overridings
zinit load "$DOTFILES/custom"

# Autoload zsh completion
autoload -Uz compinit
compinit
