#!/bin/sh
echo "=== Removing symbolic links..."
rm $HOME/.profile
rm $HOME/.profile.mac
rm $HOME/.bash_aliases
rm $HOME/.ideavimrc
rm $HOME/.gitconfig
rm $HOME/.gitignore_global
rm $HOME/.commit_template.txt
rm $HOME/.vimrc
rm $HOME/bin

# .profile_private contain sensitive data I don't want checked into github
# This removes the link if it exists
if [ -h $HOME/.profile.private ]; then
    rm $HOME/.profile.private
fi

echo "=== Done"
