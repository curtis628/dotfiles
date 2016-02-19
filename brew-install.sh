#!/bin/sh

# From brew.sh site
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# NOTE: Might need to install XCode before some of these...
brew install bash-completion
brew install bash-git-prompt
brew install kdiff3
brew install tomcat7
brew install rabbitmq 
brew install vim
brew install macvim
brew install jq
brew install python
brew install cask

brew cask install dockertoolbox
brew cask install vagrant
brew cask install rbtools

# Handy completion support
brew tap homebrew/completions
brew install homebrew/completions/brew-cask-completion
brew install homebrew/completions/brew-docker-completion
brew install homebrew/completions/docker-compose-completion
brew install homebrew/completions/docker-machine-completion
brew install homebrew/completions/maven-completion
brew install homebrew/completions/vagrant-completion

