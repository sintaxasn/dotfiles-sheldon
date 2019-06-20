#!/usr/bin/env bash
# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  fi

fi

BOOTSTRAP_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIRECTORY="$(dirname "$BOOTSTRAP_DIRECTORY")"

cd "$BOOTSTRAP_DIRECTORY" || exit 1
source utils.sh

main() {
  # Find the list of bootstraps scripts in the current folder
  options=()
  for filename in bootstrap_*.sh; do
    filename="${filename#bootstrap_}"
    filename="${filename%.*}"
    options+=("$filename")
  done

  # Prompt the user to select a bootstrap type
  prompt_choice "Please select a bootstrap type" "${options[@]}" || abort

  # Run the bootstrap script
  source bootstrap_$USER_CHOICE.sh

  heading --after 2 "Complete! ✨ 🍰 ✨"
}

main "$@"
