function prelude-prep -d "Download and setup config to run commands against a prelude instance"
  set -l usage "Usage:\n" \
              "    prelude-prep [--context CONTEXT] [-name NAME] [--namespace NAMESPACE] [--user USER] \n"
  set -l help "Download and setup configuration needed to run kubectl commands against a prelude instance.\n"\
              "You will be prompted to enter the hostname of the prelude appliance you wish to connect to.\n\n" \
              "Examples:\n"\
              "    #Download and store config to ~/.kube/custom.config. You will be prompted to enter the prelude hostname.\n" \
              "    prelude-prep -n custom.config\n\n" \
              "Options:\n" \
              "    -c, --context='': The name of the k8s context to use. Default: kubernetes-admin@kubernetes\n" \
              "    --host='': The prelude appliance host to connect to. Default: $CAVA\n" \
              "    --name='': The filename to store the kubeconfig to in ~/.kube. Default: cava-config\n" \
              "    --namespace='': The default namespace to use for this kubeconfig. Default: prelude\n" \
              "    -u, --user='': The username to SSH into the prelude appliance with. Default: root\n\n" \
              "$usage"
  set -l context kubernetes-admin@kubernetes
  set -l va_host $CAVA
  set -l name cava-config
  set -l namespace prelude
  set -l _user root

  getopts $argv | while read -l key value
    switch $key
      case c context
        set context $value
      case hostname
        set va_host $value
      case name
        set name $value
      case namespace
        set namespace $value
      case u user
        set _user $value
      case h help
        echo -e $help
        return
      end
  end

  set -l prelude_config /Users/tcurtis/.kube/$name
  echo -e \nEstablishing SSH connection to $_user@$va_host ...
  ssh-copy-id $_user@$va_host

  echo "Running let_me_in.sh script to allow our IP access through the appliance's firewall"
  ssh $_user@$va_host /opt/scripts/let_me_in.sh 600000
  
  echo -e \nDownloading kubeconfig file to: $prelude_config
  ssh $_user@$va_host kubectl config view --flatten | sed "s/vra-k8s.local/$va_host/g" > $prelude_config

  echo -e \nConfiguring k8s context=$context to use default namespace=$namespace
  set -x KUBECONFIG $prelude_config
  kubectl config set-context $context --namespace $namespace

  echo -e \n$va_host currently has the following pods on the namespace=$namespace
  kubectl get pods

  echo -e \nConnect to k8s on $va_host using: set -x KUBECONFIG $prelude_config
end
