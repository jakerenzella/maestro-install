#!/bin/bash
GIT_MACOS_REPO=https://github.com/dstil/maestro

INSTALL_PATH="/opt/jakemaestro"

command -v git >/dev/null 2>&1 || { echo "Developer tools not installed, please run: \"xcode-select --install\" in the terminal and then rerun this script." >&2; exit;}

git clone --depth 1 --branch master $GIT_MACOS_REPO "${INSTALL_PATH}"
