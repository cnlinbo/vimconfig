#!/bin/bash

project_path=$(cd `dirname $0`;pwd)
echo "Copying .vim and .vimrc to your home directory..."
echo "$project_path/.vimrc -> $HOME/.vimrc"
/bin/cp $project_path/.vimrc ~
echo "$project_path/.vim -> $HOME/.vim"
/bin/cp -r $project_path/.vim ~
if [ "$1" == "desktop" ]; then
    echo "Downloading markdown-preview binary file..."
    cd ~/.vim/plugged/markdown-preview.nvim/app
    ./install.sh
fi
echo "Install successfully!"

