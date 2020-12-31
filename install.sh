#!/bin/bash


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Required packages
    packages_needed='wget curl'
    
    # Identify system package manager and install required packages
    if [ -x "$(command -v pacman)" ]; then
        sudo pacman -S $packages_needed    # btw i use arch

    elif [ -x "$(command -v apt)" ]; then
        sudo apt install $packages_needed

    elif [ -x "$(command -v apk)" ]; then
        sudo apk add --no-cache $packages_needed

    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf install $packages_needed

    elif [ -x "$(command -v yum)" ]; then
        sudo yum install $packages_needed
    
    else
        echo "Could not find a working package manager on your system. Exiting..."; exit 1
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Get homebrew
    # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Install packages and casks from homebrew
    # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/archwl/Dotfiles/main/Homebrew/brewfile.sh)"
    # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/archwl/Dotfiles/main/Homebrew/caskfile.sh)"


    # Set wallpaper
    if [[ "$OSTYPE" == "darwin20"* ]]; then
        # Big Sur
        osascript -e "$(curl -fsSL https://raw.githubusercontent.com/archwl/Dotfiles/main/Wallpapers/set_wall.bigsur.scpt)"
    elif [[ "$OSTYPE" == "darwin19"* ]]; then
        # Catalina
        osascript -e "$(curl -fsSL https://raw.githubusercontent.com/archwl/Dotfiles/main/Wallpapers/set_wall.catalina.scpt)"
    elif [[ "$OSTYPE" == "darwin18"* ]]; then
        # Mojave
        osascript -e "$(curl -fsSL https://raw.githubusercontent.com/archwl/Dotfiles/main/Wallpapers/set_wall.mojave.scpt)"
    fi

    # Silence motd
    touch ~/.hushlogin

    # Show hidden files
    defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder

    # Enhance bluetooth audio bitpool
    defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Max (editable)" 80
    defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" 80
    defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool (editable)" 80
    defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool Min (editable)" 80
    defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool" 80
    defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Max" 80
    defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Min" 80
    

# Setup VSCode
if [ -x "$(command -v code)" ]; then
    code --install-extension jolaleye.horizon-theme-vscode
fi

else
    echo "This script does not work with $OSTYPE"
    exit 1
fi

# Create a ~/.config directory if it does not exist
if ! test -f "~/.config"; then
    mkdir ~/.config
fi

# Create a backup folder with old dotfiles
if ! test -f "~/Desktop/Old-Config-Backup"; then
    mkdir ~/Desktop/Old-Config-Backup
fi

# (W)Get the actual dotfiles
if test -f "~/.zshrc"; then
    mv ~/.zshrc ~/Desktop/Old-Config-Backup/zshrc-$(date +"%T")
    wget https://raw.githubusercontent.com/archwl/Dotfiles/main/Zsh/zshrc.zsh -O ~/.zshrc
else
    wget https://raw.githubusercontent.com/archwl/Dotfiles/main/Zsh/zshrc.zsh -O ~/.zshrc
fi


if test -f "~/.vimrc"; then
    mv ~/.vimrc ~/Desktop/Old-Config-Backup/vimrc-$(date +"%T")
    wget https://raw.githubusercontent.com/archwl/Dotfiles/main/Vim/vimrc -O ~/.vimrc
else
    wget https://raw.githubusercontent.com/archwl/Dotfiles/main/Vim/vimrc -O ~/.vimrc
fi


if test -f "~/.tmux.conf"; then
    mv ~/.tmux.conf ~/Desktop/Old-Config-Backup/tmux.conf-$(date +"%T")
    wget https://raw.githubusercontent.com/archwl/Dotfiles/main/Tmux/tmux.conf -O ~/.tmux.conf
else
    wget https://raw.githubusercontent.com/archwl/Dotfiles/main/Tmux/tmux.conf -O ~/.tmux.conf
fi


wget https://raw.githubusercontent.com/archwl/Dotfiles/main/iTerm/iterm.conf.json -O ~/Desktop/iTerm-Profile-$(date +"%T")
wget https://raw.githubusercontent.com/archwl/Dotfiles/main/Alacritty/alacritty.yml -O ~/Desktop/alacritty.yml-$(date +"%T")

# Set up Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c PluginInstall -c q -c q

# Set up TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source-file ~/.tmux.conf
~/.tmux/plugins/tpm/bin/install_plugins
tmux source-file ~/.tmux.conf

