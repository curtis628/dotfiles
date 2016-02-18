#!/bin/sh
echo "=== Creating symbolic links..."
ln -s $PWD/profile          $HOME/.profile
ln -s $PWD/bash_aliases     $HOME/.bash_aliases
ln -s $PWD/ideavimrc        $HOME/.ideavimrc
ln -s $PWD/gitconfig        $HOME/.gitconfig
ln -s $PWD/gitconfig_global $HOME/.gitconfig_global
ln -s $PWD/vimrc            $HOME/.vimrc

echo "=== Sourcing my new .profile"
source $HOME/.profile

echo "=== Checking out vundle (used to manage VIM plugins)..."
git submodule update --init

echo "=== Installing VIM plugins with Vundle..."
vim +BundleInstall +qall

echo "=== Done"
