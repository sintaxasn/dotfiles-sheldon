#!/usr/bin/env bash

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
install_package "unzip" "Unzip"

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

cd ~/
wget -c https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip
unzip exa-linux-x86_64-0.8.0.zip
sudo mv exa-linux-x86_64 /usr/local/bin/exa
sudo chmod +x /usr/local/bin/exa
rm exa-linux-x86_64-0.8.0.zip
