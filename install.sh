#!/bin/bash
GIT_MACOS_REPO_PROD=https://github.com/dstil/maestro
GIT_MACOS_REPO_TEST=https://github.com/jakerenzella/maestro
INSTALL_PATH="/opt/maestro"

# Test for root password and quit if incorrect, caches password if correct.
if [[ "$EUID" = 0 ]]; then
    echo "(1) already root"
else
    sudo -k # make sure to ask for password on next sudo
    if sudo true; then
        echo "Correct sudo password."
    else
        echo "Incorrect password, please rerun script"
        exit 1
    fi
fi

# Check for and enable command line tools.
command -v git >/dev/null 2>&1 || 
{
    echo "Enabling Command Line Tools.."
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
    PROD=$(softwareupdate -l |
    grep "\*.*Command Line" |
    head -n 1 | awk -F"*" '{print $2}' |
    sed -e 's/^ *//' |
    tr -d '\n')
    softwareupdate -i "$PROD" --verbose;
}

# Install brew if is not already Installed
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update
brew install git

sudo rm -rf $INSTALL_PATH
sudo mkdir -p $INSTALL_PATH

sudo git clone --depth 1 --single-branch --branch enhance/add-update-functionality $GIT_MACOS_REPO_TEST $INSTALL_PATH
/opt/maestro/install.sh
