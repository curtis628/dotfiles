# Set the default editor to vim.
export EDITOR=vim
 
# Avoid succesive duplicates in the bash command history.
export HISTCONTROL=ignoredups
 
# Append commands to the bash command history file (~/.bash_history)
# instead of overwriting it.
shopt -s histappend
 
# Append commands to the history every time a prompt is shown,
# instead of after closing the session.
PROMPT_COMMAND='history -a'

export MAVEN_OPTS="-Xmx2048m"
export PATH=$HOME/bin:$PATH

# Tomcat-specific
export CATALINA_BASE=~/tomcat7

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# profile.private is not checked into git
if [ -f ~/.profile.private ]; then
    source ~/.profile.private
fi

unamestr=`uname`
# OSX = Darwin
if [[ ( "$unamestr" == 'Darwin' ) && ( -f ~/.profile.mac ) ]]; then
    source ~/.profile.mac
fi

if [ -f ~/workspace/dotfiles/bash-git-prompt/gitprompt.sh ]; then
    # Set config variables first
    # GIT_PROMPT_THEME=Default
    GIT_PROMPT_THEME=Solarized         # use theme optimized for solarized color scheme
    GIT_PROMPT_ONLY_IN_REPO=0 
    # GIT_PROMPT_FETCH_REMOTE_STATUS=0 # uncomment to avoid fetching remote status
    source ~/workspace/dotfiles/bash-git-prompt/gitprompt.sh
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Helpful commands for symphony/heimdall development
export SYMPHONY_SRC=/Users/tcurtis/workspace/symphony
export HEIMDALL_SRC=/Users/tcurtis/workspace/heimdall
export SYMPHONY_INFRA_SRC=/Users/tcurtis/workspace/symphony-infra
export DEPLOYMENT_PREFIX=minikube
