#Make some possibly destructive commands more interactive.
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
 
# Add some easy shortcuts for directory listings and add a touch of color.
# ls options:
# -h: human-readable units
# -F: Add '*' for executables, '@' for symlinks, '/' for directories, etc.
# -G: Add color output
alias ll='ls -lhFG'
alias la='ls -alhFG'
alias ls='ls -hFG'
alias lsd="ls -alhFG | grep /$"
alias back='cd $OLDPWD'

# Some maven aliases...
alias mci="mvn clean install"
alias mcis="mvn clean install -DskipTests -PgwtSpeedup -Dgwt.compile.user.agent=chrome -DskipLibs=true -Denunciate.skip=true -DskipDocs "
alias gobuild_master="gobuild sandbox queue --accept-defaults --branch master --changeset master vcac-suite"
alias gobuild_vrva="gobuild sandbox queue vrva --branch master --buildtype beta --no-changeset --accept-defaults --no-store-trees --component-builds vcac-suite=sb-$SB_VCAC_SUITE_BUILD_NUM --override-branch"

# Some git aliases
alias gitroot='git rev-parse --show-cdup'
alias cdgitroot='cd ./$(gitroot)'

# Some docker aliases
alias dockerip='export DHOST=$(docker-machine ip default)'
alias init_docker='eval $(docker-machine env default)'
# Useful if using Docker for Mac and boot2docker vars are set
alias uninit_docker='unset ${!DOCKER_*}'
alias set_docker_api_version='export DOCKER_API_VERSION=1.23'

# k8s aliases
alias busybox_kubectl='kubectl run test-pod --image=radial/busyboxplus:curl -it --restart=Never --rm'
alias k8s_localrouteadd='sudo route add 10.0.0.0/24 192.168.99.100'
alias k8s_localroutedelete='sudo route delete 10.0.0.0/24 192.168.99.100'
alias k8s_opensymphony='open http://`kubectl get service heimdall-service --output=jsonpath="{.spec.clusterIP}"`/loginui'
alias kpod='kubectl get pod -o wide'
 
# Make grep more user friendly by highlighting matches
alias grep='grep --color=auto'

# Make Windows 'cls' map to Unix 'clear'
alias cls='clear'

# Alias to pretty-print XML and JSON  using python
alias ppxml='python -c "import sys, xml.dom.minidom; print xml.dom.minidom.parseString(sys.stdin.read()).toprettyxml()"'
alias ppjson='python -mjson.tool'

# Easily switch between Java versions
alias j7='export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)'
alias j8='export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)'

# Shortcuts to other apps
alias xpra='/Applications/Xpra.app/Contents/MacOS/Xpra'
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

# Tomcat aliases
alias tclogs='cd $CATALINA_BASE/logs'
alias tcwebapps='cd $CATALINA_BASE/webapps'
alias tcstart='$CATALINA_HOME/bin/catalina.sh start'
#alias tcstart='$CATALINA_HOME/bin/catalina.sh jpda start'
alias tcstop='$CATALINA_HOME/bin/catalina.sh stop'

# Productivity shortcuts
function mkdircd () { mkdir -p "$1" && cd "$1"; }
