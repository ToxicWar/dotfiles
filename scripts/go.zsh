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
  info '   _____         '
  info '  / ____|        '
  info ' | |  __  ___    '
  info ' | | |_ |/ _ \   '
  info ' | |__| | (_) |  '
  info '  \_____|\___/   '
  info '                 '
  info "This script will guide you through installing Go."
  echo
  ask "Do you want to proceed with installation?" && read answer
  echo
  if [[ "${answer}" != "y" ]]; then
    exit 1
  fi
}

install_go() {
  # Install go
  info "Installing go..."

  brew install go

  finish
}


on_finish() {
  success "Done!"
  success "Go is installed!"
  echo
}

on_error() {
  error "Wow... Something serious happened!"
  error "Though, I don't know what really happened :("
  exit 1
}

main() {
  on_start "$*"
  install_go "$*"
}

main "$*"
