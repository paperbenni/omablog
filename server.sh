#!/bin/bash

echo "starting omablog"
cd ~/oma/ || exit 1

if ! find . | grep -q 'posts.html'
then
    echo "no posts found"
    exit 1
fi

busybox httpd -p 8088 .

while :
do
    sleep 10
    if ! pgrep httpd
    then
        busybox httpd -p 8088 .
    fi
done


