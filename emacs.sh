#!/bin/bash

# This version works with the homebrew build of emacs
emacs_server="/Applications/Emacs.app/Contents/MacOS/Emacs"
emacs_client="/usr/local/bin/emacsclient"

if [[ $# -gt 1 ]]; then
    if [ "$1" == "-batch" ] || [ "$1" == "--batch" ]; then
	echo "Emacs compiler mode with: $@"
	$emacs_server "$@"
	exit 
    fi
fi

emacs_server_pattern="Emacs.app/Contents/MacOS/Emacs"
server_pid=$(ps aux | grep -v grep | grep -Ei "${emacs_server_pattern}" | awk '{print $2}')
# Check if there is already an emacs process (has to be written like this)
if [ ! -z "${server_pid}" ]; then
    #if [ `pgrep -f 'Emacs.*--daemon'` ]; then
    which osascript > /dev/null 2>&1 && \
	osascript -e 'tell application "Emacs" to activate'
    # Get the number of all frames
    num_frames=$(${emacs_client} -e '(length (frame-list))')
    if [[ $num_frames -lt 2 ]]; then args=-nc; else args=-n; fi
    ${emacs_client} ${args} --quiet --no-wait "$@"
else
    echo "Initializing emacs server"    
    ${emacs_server} --no-splash "$@" &
fi
