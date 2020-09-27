#!/bin/bash

# make this a termux shortcut

checkcmd() {
    if ! command -v "$1" &>/dev/null; then
        echo "$1 missing, please install"
        exit 1
    fi
}

checkcmd rsync
checkcmd ssh
checkcmd ping
checkcmd sshpass
checkcmd busybox

if [ -e ~/.omapass ]; then
    source ~/.omapass
elif [ -e ~/omapass ]; then
    source ~/omapass
fi

cd ~/workspace/omablog || exit 1

if [ -z "$OMAPASS" ]
then
    echo "omapass not set "
    exit 1
fi

if ! ping -c 1 mc.paperbenni.xyz
then
    echo "kein internet"
    sleep 1
else
        sshpass -p "$OMAPASS" rsync -Pza "omablog@$OMASERVER:/home/omablog/oma/" ~/oma
fi 

if ! pgrep busybox
then
    ~/workspace/omablog/server.sh & 
    sleep 10
    cd ~/workspace/omablog/ || echo "error"
    git pull
fi

termux-open-url http://localhost:8088/"$OMAADRESS"/blog.html

