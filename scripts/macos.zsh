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

# This file contains settings for MacOs which I use.

info 'Configuring mac.'

# === General ===

# Show remaining battery percentage
defaults write com.apple.menuextra.battery ShowPercent YES

# Always use expanded save dialog:
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Never show screensaver
defaults -currentHost write com.apple.screensaver idleTime -int 0


# === Dock ===

# Set Dock default tile size
defaults write com.apple.dock tilesize -int 36

# Enable Dock magnification
defaults write com.apple.dock magnification -bool true

# Set Dock large tile size
defaults write com.apple.dock largesize -int 58

# Show indicators in Dock
defaults write com.apple.dock show-process-indicators -bool true

# Use scale for minimaze windows
defaults write com.apple.dock mineffect -string "scale"

# Minimaze window into application
defaults write com.apple.dock minimize-to-application -bool true

# Still expirements with autohide of Dock
# defaults write com.apple.dock autohide -bool true
# defaults write com.apple.dock autohide-time-modifier -float 0.5
# defaults write com.apple.dock autohide-delay -float 0


# === Finder ===

# Keep folders on top when sorting by name:
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Show Finder path bar:
defaults write com.apple.finder ShowPathbar -bool true

# Do not show status bar in Finder:
defaults write com.apple.finder ShowStatusBar -bool false

# Show file extensions in Finder:
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show Library folder
chflags nohidden ~/Library


# === Calendar ===

# Show Monday as first day of the week
defaults write com.apple.iCal "first day of week" -int 1


# Kill affected apps
info "Restarting apps..."
for app in "Dock" "Finder" "SystemUIServer"; do
  killall "${app}" > /dev/null 2>&1
done

# Done
info "Done. Note that some of these changes require a logout/restart to take effect."
