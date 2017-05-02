#!/bin/bash

_bsd_="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


os_name=$(uname -s | tr '[:upper:]' '[:lower:]')
os_emacs_exec="${_bsd_}/emacs.${os_name}"
echo "OS detected: ${os_name}"

function update_darwin() {
    # Cask has better support for cocoa
    brew cask install emacs || echo "Okay"

    if [ -f "${os_emacs_exec}" ]; then
        rm -f /usr/local/bin/emacs
        cp "${os_emacs_exec}" /usr/local/bin/emacs
        chmod +x /usr/local/bin/emacs
    fi
}

function update_linux() {
    echo "Nothing to do at the moment"
    return 0
}

case "${os_name}" in 
    darwin) update_darwin 
           ;;
    linux) update_linux 
            ;;
    \?)
        echo "the operating system ${os_name} is not supported"; exit
        ;;
esac

(cd "${_bsd_}"
 git submodule foreach 'git checkout master ; git pull; if [ -f Makefile ]; then make clean && make; fi'
)
