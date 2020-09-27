#!/bin/bash

if command -v termux-setup-storage
then
    BASHPATH="$(which bash)"
fi

cd ~/workspace/omablog

for i in ./*.sh
do
    sed -i '1s~.*~'"$BASHPATH" "$i"
done
