#!/bin/sh

# From brew.sh site
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# NOTE: Likely need to install XCode before this succeeds...
brew install bash-completion git bash-git-prompt kdiff3 tomcat7 rabbitmq vim macvim jq python cask
brew cask install dockertoolbox vagrant
