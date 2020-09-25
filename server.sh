#!/bin/bash

echo "starting omablog"

if [ -z "$OMAADRESS" ]
then
    echo "please set OMAADRESS"
    exit 1
fi

if ! [ -e ~/oma/"$OMAADRESS"/blog.html ]
then
    echo "pulling blog"
    mkdir ~/workspace &> /dev/null
    mkdir -p ~/oma/"$OMAADRESS" &> /dev/null
    git clone --depth=1 https://github.com/paperbenni/omablog ~/workspace/omablog
    # init new blog
    {
        cat ~/workspace/omablog/blog.html
        cat ~/workspace/omablog/example.html
        cat ~/workspace/omablog/end.html
    } > ~/oma/"$OMAADRESS"/blog.html
    cat ~/workspace/omablog/example.html > ~/oma/"$OMAADRESS"/posts.html
fi

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
    if ! pgrep httpd &> /dev/null && ! pgrep busybox &> /dev/null
    then
        busybox httpd -p 8088 .
    fi
done


