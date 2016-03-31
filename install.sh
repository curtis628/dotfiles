#!/bin/sh
echo "=== Creating symbolic links..."
ln -s $PWD/profile             $HOME/.profile
ln -s $PWD/profile.mac         $HOME/.profile.mac
ln -s $PWD/bash_aliases        $HOME/.bash_aliases
ln -s $PWD/ideavimrc           $HOME/.ideavimrc
ln -s $PWD/gitconfig           $HOME/.gitconfig
ln -s $PWD/gitignore_global    $HOME/.gitignore_global
ln -s $PWD/commit_template.txt $HOME/.commit_template.txt
ln -s $PWD/vimrc               $HOME/.vimrc
ln -s $PWD/bin/                $HOME/bin

# .profile_private contain sensitive data I don't want checked into github
# This links it so I can use it, but won't fail if someone reuses my dotfiles
if [ -f $PWD/profile.private ]; then
    ln -s $PWD/.profile.private $HOME/.profile.private
fi

echo "=== Checking out git submodules: vundle (used to manage VIM plugins) and bash-git-prompt"
git submodule update --init

echo "=== Sourcing my new .profile"
source $HOME/.profile

echo "=== Installing VIM plugins with Vundle..."
vim +BundleInstall +qall

echo "=== Done"
