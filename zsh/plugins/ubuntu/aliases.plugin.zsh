#!/usr/bin/env zsh

# Lock screen
alias afk="gnome-screensaver-command -l"

# Copy to clipboard
alias copy="xclip -selection clipboard"

# Shortcut for capslock toggle script
alias cl="capslock"

# Set keyboard to Colemak
cm() {
setxkbmap us -variant colemak
xset r 66
echo "Keyboard set to Colemak"
}

# Set keyboard to QWERTY
qw() {
setxkbmap us
xset -r 66
echo "Keyboard set to QWERTY"
}
