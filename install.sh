#!/usr/bin/env bash

cd $(dirname 0)
ln -snFi $(pwd)/bash/profile.sh ~/.bash_profile
ln -snFi $(pwd)/vim/vimrc.bundles.local ~/.vimrc.bundles.local
ln -snFi $(pwd)/vim/vimrc.local ~/.vimrc.local
ln -snFi $(pwd)/bin ~/bin
ln -snFi $(pwd)/gitconfig ~/.gitconfig
mkdir -p ~/.bak
git submodule update
(cd maximum-awesome && rake)


