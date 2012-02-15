#!/usr/bin/env bash

cd $(dirname 0)
ln -snFi $(pwd)/bash/profile.sh ~/.bash_profile
ln -snFi $(pwd)/vim ~/.vim
ln -snFi $(pwd)/vim/vimrc ~/.vimrc
ln -snFi $(pwd)/vim/gvimrc ~/.gvimrc
ln -snFi $(pwd)/bin ~/bin
ln -snFi $(pwd)/gitconfig ~/.gitconfig
mkdir -p ~/.bak


