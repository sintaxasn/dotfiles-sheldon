#!/usr/bin/env bash

if [[ -f /proc/version ]] && grep -q "Microsoft" /proc/version; then
  # Fix umask value if WSL didn't set it properly.
  # https://github.com/Microsoft/WSL/issues/352
  [[ "$(umask)" == "000" ]] && umask 022

  cat << EOF | sudo tee /etc/wsl.conf
[automount]
enabled = true
root = /mnt/
options = "metadata,umask=22,fmask=111"
EOF

fi

heading "Configuration"

if confirm --before 1 "Install Python development tools?"
then
  INSTALL_PYTHON_TOOLS=true
fi

if confirm "Install Rust development tools?"
then
  INSTALL_RUST_TOOLS=true
fi

request_sudo || abort

heading "General"

subheading "System packages"
update_package_manager
install_package "bash" "Bash"
install_package "curl" "cURL"
install_package "git" "Git"
install_package "make"
install_package "tmux"
install_package "tmuxinator"
install_package "xclip"
install_package "vim" "Vim"
install_package "wget" "Wget"
install_package "zsh" "Zsh"
install_package "zsh-antigen" "Zsh Antigen"
install_package "zsh-autosuggestions" "zsh-autosuggestions"
install_package "zsh-syntax-highlighting" "zsh-syntax-highlighting"
install_package "unzip" "Unzip"
install_package "unrar" "Unrar"
install_package "colordiff" "colordiff"
install_package "coreutils" "coreutils"
install_package "exa" "exa"
install_package "tar" "tar"
install_package "gnupg" "gnupg"
install_package "golang" "golang"
install_package "grc" "grc"
install_package "hub" "hub"
install_package "jq" "jq"
install_package "nano" "nano"
install_package "neovim" "neovim"
install_package "vim" "Vim"

install_exa

subheading "Remote repositories"
clone_oh_my_zsh
clone_base16_shell_theme

subheading "Vim plugins"
clone_vim_flake8_plugin
clone_vim_base16_themes

subheading "Configurations"
symlink "curl/curlrc"             ".curlrc"
symlink "git/gitconfig"           ".gitconfig"
symlink "git/gitignore_global"    ".gitignore_global"
symlink "tmux/tmux.conf"          ".tmux.conf"
symlink "vim/vimrc"               ".vimrc"
symlink "vscode/settings.json"    ".config/Code/User/settings.json"
symlink "vscode/keybindings.json" ".config/Code/User/keybindings.json"
symlink "zsh/aliases/ubuntu"      ".aliases"
symlink "zsh/plugins/ubuntu"      ".plugins"
symlink "zsh/zshrc"               ".zshrc"
symlink "nano/nanorc"             ".nanorc"
symlink "nano/nano"               ".nano"

subheading "Scripts"
symlink "bin/gensshkey.sh" ".local/bin/gensshkey"
symlink "bin/ips.py"       ".local/bin/ips"

if [ "$INSTALL_PYTHON_TOOLS" = true ]
then
  heading "Python development"

  subheading "System packages"
  install_packages "build-essential" "llvm"
  install_packages "libbz2-dev" "libffi-dev" "liblzma-dev" "libncurses5-dev" "libreadline-dev" \
                   "libsqlite3-dev" "libssl-dev" "libxml2-dev" "libxmlsec1-dev" "zlib1g-dev"

  subheading "Environment"
  install_pyenv
  install_pyenv_python2
  install_pyenv_python3
  create_pyenv_virtualenv

  subheading "Packages"
  install_python_package "awscli"
  install_python_package "flake8" "Flake8"
fi

if [ "$INSTALL_RUST_TOOLS" = true ]
then
  heading "Rust development"

  subheading "Environment"
  install_rustup

  subheading "Packages"
  install_rustup_component "clippy"
  install_rustup_component "rustfmt"
  install_cargo_package "cargo-edit"
fi
