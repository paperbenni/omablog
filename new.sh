#!/bin/bash

# import paperbash
source <(curl -Ls https://git.io/JerLG)
pb dialog

mkdir -p ~/.cache/omablog
cd ~/.cache/omablog || exit 1

if [ -z "$OMAURL" ] || [ -z "$OMASERVER" ]; then
    echo "not logged in"
    exit 1
fi

if ! [ -e ~/workspace/omablog ]; then
    echo "pulling blog"
    mkdir ~/workspace
    git clone --depth=1 https://github.com/paperbenni/omablog ~/workspace/omablog
fi

pullblog() {
    curl -s "$OMAURL/posts.html" >posts.html
}

checkcmd() {
    if ! command -v "$1"; then
        echo "$1 missing, please install"
        exit 1
    fi
}

checkcmd fzf
checkcmd git
checkcmd dialog

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

cat ~/workspace/omablog/blog.html > finished.html
cat newpost.html >> finished.html
cat ~/workspace/omablog/end.html >> finished.html

echo "finished"
