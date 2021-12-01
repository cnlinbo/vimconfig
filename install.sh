#!/bin/bash

project_path=$(cd `dirname $0`;pwd)
/bin/cp $project_path/.vimrc ~/.vimrc
/bin/cp -r $project_path/.vim ~/.vim
if [ "$1" == "desktop" ]; then
    ~/.vim/plugged/markdown-preview.nvim/app/install.sh
fi