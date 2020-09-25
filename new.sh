#!/bin/bash

# omablog: super simple blogging/link aggregation system

if [ -z "$OMASERVER" ] ||
    [ -z "$OMAADRESS" ] ||
    [ -z "$OMAPASS" ]; then

    echo "not logged in"
    exit 1
fi

checkcmd() {
    if ! command -v "$1" &> /dev/null; then
        echo "$1 missing, please install"
        exit 1
    fi
}

checkcmd git
checkcmd rsync
checkcmd ssh

mkdir -p ~/.cache/omablog
cd ~/.cache/omablog || exit 1

if ! [ -e ~/workspace/omablog ]; then
    echo "pulling blog"
    mkdir ~/workspace
    git clone --depth=1 https://github.com/paperbenni/omablog ~/workspace/omablog
fi

pullblog() {
    curl -s "http://$OMASERVER:8088/$OMAADRESS/posts.html" >posts.html
}

if [ -z "$2" ]; then
    if [ -n "$1" ]; then
        CONTENT="$1"
    else
        echo 'oma "link" "titel" "text"'
        exit 1
    fi
else
    LINK="$1"
    BUTTONTEXT="$2"
    if [ -n "$3" ]; then
        CONTENT="$3"
    fi
fi

if [ -n "$LINK" ]; then
    echo '<a href="'"$LINK"'" class="pure-button postbutton" target="_blank">'"$BUTTONTEXT"'</a>' >newpost.html
fi

if [ -n "$CONTENT" ]; then
    echo "no content"
else
    {
        echo '<p class="postbutton">'
        echo "$CONTENT"
        echo '</p>'
    } >>newpost.html
fi
echo '<hr>' >>newpost.html

cat ~/workspace/omablog/blog.html >finished.html

{
    cat newpost.html
    cat posts.html
    cat ~/workspace/omablog/end.html
} >>finished.html

echo "finished"

rsync sync -P ~/.cache/omablog/ "omablog@$OMASERVER:/home/omablog/$OMAADRESS"

