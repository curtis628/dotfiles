# Set the PS1 prompt (with colors).
# Based on http://www-128.ibm.com/developerworks/linux/library/l-tip-prompt/
# And http://networking.ringofsaturn.com/Unix/Bash-prompts.php .
# NOTE: Abandoned this prompt in favor of bash-git-prompt
#MY_PROMPT="\[\e[36;1m\]\h:\[\e[32;1m\]\w \[\e[0m\]"
#PS1=$MY_PROMPT

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

export PYTHONPATH=/usr/local/lib/python2.7/site-packages
export TCROOT=/build/toolchain
export BUILDAPPSROOT=/build/apps
export BUILDAPPS=$BUILDAPPSROOT/bin
export MAVEN_OPTS="-Xmx2048m -XX:MaxPermSize=512m"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_79.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jre1.7.0_80.jre/Contents/Home
export BREW_BIN=/usr/local/bin
export BREW_SBIN=/usr/local/sbin
export PATH=$HOME/bin:$BREW_BIN:$BREW_SBIN:$BUILDAPPSROOT/bin:$PATH

# Tomcat-specific
export CATALINA_HOME=/usr/local/Cellar/tomcat7/7.0.65/libexec
export CATALINA_BASE=~/tomcat7

# Perforce-related (for local apps/toolchain)
export P4CONFIG=.p4config
export P4USER=$USER
export TOOLCHAIN_P4CLIENT=$USER-mbp-toolchain
export TOOLCHAIN_P4SERVER=perforce-toolchain.eng.vmware.com:1666
export APPS_P4CLIENT=$USER-mbp-apps
export APPS_P4SERVER=perforce-releng.eng.vmware.com:1850

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
  complete -C aws_completer aws
fi

if [ -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]; then
  # Set config variables first
  GIT_PROMPT_THEME=Default
  GIT_PROMPT_ONLY_IN_REPO=0 
  # GIT_PROMPT_FETCH_REMOTE_STATUS=0 # uncomment to avoid fetching remote status
  GIT_PROMPT_THEME=Solarized       # use theme optimized for solarized color scheme
  source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
fi
