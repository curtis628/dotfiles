function prelude-prep -d "Download and setup config to run commands against a prelude instance"
  set -l usage "Usage:\n" \
              "    prelude-prep [--context CONTEXT] [-name NAME] [--namespace NAMESPACE] [--user USER] [--scripts] [--vidm] \n"
  set -l help " Download and setup configuration needed to run kubectl commands against a prelude instance.\n"\
              "Examples:\n"\
              "    #Download and store config to ~/.kube/custom.config.\n" \
              "    prelude-prep --host=vra.test.com -n custom.config\n\n" \
              "Options:\n" \
              "    -c, --context='': The name of the k8s context to use. Default: kubernetes-admin@kubernetes\n" \
              "    --host='': The prelude appliance host to connect to. Default: $CAVA\n" \
              "    --name='': The filename to store the kubeconfig to in ~/.kube. Default: cava-config\n" \
              "    --namespace='': The default namespace to use for this kubeconfig. Default: prelude\n" \
              "    -u, --user='': The username to SSH into the prelude appliance with. Default: root\n" \
              "    -s, --scripts: Uploads .profile and scripts to facilitate debugging\n" \
              "    --vidm: Initialize VIDM to run e2e tests\n\n" \
              "$usage"
  set -l context kubernetes-admin@kubernetes
  set -l va_host $CAVA
  set -l name cava-config
  set -l namespace prelude
  set -l _user root
  set -l scripts false
  set -l vidm_init false
  set -l ssh_identity ~/.ssh/id_rsa

  getopts $argv | while read -l key value
    switch $key
      case c context
        set context $value
      case host
        set va_host $value
      case name
        set name $value
      case namespace
        set namespace $value
      case u user
        set _user $value
      case s scripts
        set scripts $value
      case vidm
        set vidm_init $value
      case h help
        echo -e $help
        return
      end
  end

  set -l prelude_config /Users/tcurtis/.kube/$name
  echo Establishing SSH connection to $_user@$va_host ...
  ssh-copy-id -i $ssh_identity $_user@$va_host

  echo "Running let_me_in.sh script to allow our IP access through the appliance's firewall"
  ssh -i $ssh_identity $_user@$va_host /opt/scripts/let_me_in.sh 600000

  echo -e \nDownloading kubeconfig file to: $prelude_config
  ssh -i $ssh_identity $_user@$va_host kubectl config view --flatten | sed "s/vra-k8s.local/$va_host/g" > $prelude_config

  echo -e \nConfiguring k8s context=$context to use default namespace=$namespace
  set -x KUBECONFIG $prelude_config
  kubectl config set-context $context --namespace $namespace
  
  if $scripts
      echo -e \nConfiguring appliance with my handy .profile and latest scripts...
      scp -r $HOME/.config/fish/functions/etc $_user@$va_host:"~"
      ssh -i $ssh_identity $_user@$va_host "mkdir -p ~/bin ~/tyler"
      ssh -i $ssh_identity $_user@$va_host "mv ~/etc/.profile ~/.profile"
      scp -i $ssh_identity $HOME/workspace/dotfiles/bin/klogs-dl.sh $_user@$va_host:"~/bin/klogs-dl.sh"
      echo \nDone configuring scripts!
  end

  if $vidm_init
      echo -e \nInitialize VIDM and prelude appliances to run e2e tests...

      echo -e \nInstalling tdnf apps...
      echo ... installing git
      ssh -i $ssh_identity $_user@$va_host "tdnf install -y git" &

      echo -e \nDownloading and installing application binaries...
      echo ... OpenJDK
      set -l openjdk_version 11.0.7_10
      ssh -i $ssh_identity $_user@$va_host 'cd /root/tyler; curl -LO https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/$openjdk_version/OpenJDK11U-jdk_x64_linux_hotspot_11.0.7_10.tar.gz ; tar xf OpenJDK11U-jdk_x64_linux_hotspot_$openjdk_version.tar.gz'
      echo "... Maven"
      set -l maven_version 3.6.3
      ssh $_user@$va_host 'cd /root/tyler; curl -LO https://apache.claz.org/maven/maven-3/$maven_version/binaries/apache-maven-$maven_version-bin.tar.gz; tar xf apache-maven-$maven_version-bin.tar.gz'

      echo -e \nMoving my unix SSH keys over...
      scp -i $ssh_identity ~/.ssh/id_rsa $_user@$va_host:/root/.ssh/id_rsa
      scp -i $ssh_identity ~/.ssh/id_rsa.pub $_user@$va_host:/root/.ssh/id_rsa.pub

      # echo -e \nCloning git repositories...
      # echo ...tango-e2e
      # ssh $_user@$va_host 'cd /root/tyler; git clone ssh://tcurtis@bellevue-ci.eng.vmware.com:29418/tango-e2e'
      echo -e \n To clone a repository, use command: git clone ssh://$user@bellevue-ci.eng.vmware.com:29418/tango-e2e

      set -l vidm (prelude-prep-host --kubeconfig $prelude_config --vidm)
      echo Copying over files to VIDM: $vidm
      ssh-copy-id -i $ssh_identity root@$vidm
      scp -i $ssh_identity $HOME/bin/klogs-dl.sh root@$vidm:"~/.profile"
      scp -i $ssh_identity $HOME/.config/fish/functions/etc/.profile root@$vidm
      ssh -i $ssh_identity root@$vidm "mkdir -p /root/tyler; cd /root/tyler; scp root@$CAVA:/tyler/OpenJDK11U-jdk_x64_linux_hotspot_11.0.7_10.tar.gz"
      ssh -i $ssh_identity root@$vidm "cd /root/tyler; scp root@$CAVA:/tyler/apache-maven-3.6.3-bin.tar.gz"
  end

  echo -e \n$va_host currently has the following pods on the namespace=$namespace
  kubectl get pods

  echo -e \nConnect to k8s on $va_host using: set -x KUBECONFIG $prelude_config
end
