#!/usr/bin/env zsh

set -e
trap on_error SIGKILL SIGTERM

e='\033'
RESET="${e}[0m"
BOLD="${e}[1m"
CYAN="${e}[0;96m"
RED="${e}[0;91m"
YELLOW="${e}[0;93m"
GREEN="${e}[0;92m"


# Success reporter
info() {
  echo -e "${CYAN}${*}${RESET}"
}

ask() {
  printf "${YELLOW}${*}${RESET}"
}

# Error reporter
error() {
  echo -e "${RED}${*}${RESET}"
}

# Success reporter
success() {
  echo -e "${GREEN}${*}${RESET}"
}

# End section
finish() {
  success "Done!"
  echo
  sleep 1
}


on_start() {
  info '  _____       _   _                   '
  info ' |  __ \     | | | |                  '
  info ' | |__) |   _| |_| |__   ___  _ __    '
  info ' |  ___/ | | | __| '_ \ / _ \| '_ \   '
  info ' | |   | |_| | |_| | | | (_) | | | |  '
  info ' |_|    \__, |\__|_| |_|\___/|_| |_|  '
  info '         __/ |                        '
  info '                                      '
  info "This script will guide you through installing Python, pyenv, etc."
  echo
  ask "Do you want to proceed with installation?" && read answer
  echo
  if [[ "${answer}" != "y" ]]; then
    exit 1
  fi
}

install_pyenv() {
  # Install pyenv
  info "Installing pyenv..."

  brew install pyenv

  pyenv install 3.8.2
  pyenv global 3.8.2

  info "Activate python 3.8.2"
  eval "$(pyenv init -)"

  finish
}

install_pipx() {
  # Install pipx
  info "Installing pipx..."

  python -m pip install pipx

  finish
}

install_poetry() {
  # Install poetry
  info "Installing poetry..."

  pipx install poetry==1.0.5

  finish
}

on_finish() {
  success "Done!"
  success "Python is installed!"
  echo
}

on_error() {
  error "Wow... Something serious happened!"
  error "Though, I don't know what really happened :("
  exit 1
}

main() {
  on_start "$*"
  install_pyenv "$*"
  install_pipx "$*"
  install_poetry "$*"
}

main "$*"
