#!/bin/bash
GIT_MACOS_REPO_PROD=https://github.com/dstil/maestro
GIT_REPO_TEST=https://github.com/jakerenzella/maestro
INSTALL_PATH="/opt/maestro"

################################
# MacOS Install
################################
if [[ `uname` == Darwin ]]; then
  # Test for root password and quit if incorrect, caches password if correct.
  echo "Enter local root password for pre-install script"
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
  echo "checking for CLI tools"
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

  echo "checking for Brew"
  # Install brew if is not already Installed
  if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  echo "Updating brew."
  brew update

  echo "Installing newer version of git."
  brew install git

  echo "Installing Maestro to /opt/maestro"
  sudo rm -rf $INSTALL_PATH
  sudo mkdir -p $INSTALL_PATH

  sudo git clone --depth 1 --single-branch --branch enhance/support-ubuntu $GIT_REPO_TEST $INSTALL_PATH
  /opt/maestro/install/macos-install.sh
  exit
fi

################################
# LINUX INSTALL
################################
if [[ `uname` == Linux ]]; then
  echo "installing Maestro for Ubuntu in /opt/maestro"

  sudo rm -rf $INSTALL_PATH
  sudo mkdir -p $INSTALL_PATH

  sudo apt-get update
  sudo apt-get -y install git

  sudo git clone --depth 1 --single-branch --branch enhance/support-ubuntu $GIT_REPO_TEST $INSTALL_PATH
  sudo chmod +x /opt/maestro/install/ubuntu-install.sh
  /opt/maestro/install/ubuntu-install.sh
  echo "finished installing Maestro for Linux"
  exit
fi

################################
# Mingw
################################
if [[ `uname` == MINGW* ]] || [[ `uname` == MSYS* ]]; then
  echo "MINGW not supported"
  exit
fi

echo "Maestro is not supported on this Operating System."
