function prelude-prep-host -d "Extracts hostname from a KUBECONFIG file"
  set -l usage "Usage:\n" \
              "    prelude-prep-host [--kubeconfig CONFIG] [--vidm] \n"
  set -l help "Extracts the hostname from a kubeconfig file. Order of precedence:\n" \
              "1. --kubeconfig parameter\n" \
              "2. KUBECONFIG environment variable\n" \
              "3. $HOME/.kube/cava-config\n\n" \
              "Examples:\n"\
              "    #Extract the hostname of the provided kubeconfig file\n" \
              "    prelude-prep-host -k $HOME/.kube/cava-config\n\n" \
              "    #Extract the hostname of the KUBECONFIG file from the environment variable\n" \
              "    prelude-prep-host\n\n" \
              "    #Extract the VIDM hostname of the provided kubeconfig file\n" \
              "    prelude-prep-host -k $HOME/.kube/cava-config --vidm\n\n" \
              "Options:\n" \
              "    -k, --kubeconfig='': The kubeconfig file to use. Default: $HOME/.kube/cava-config\n" \
              "    --vidm='': Extract hostname of VIDM appliance associated to KUBECONFIG\n\n" \
              "$usage"
  set -l k_file $HOME/.kube/cava-config
  set -l vidm false

  getopts $argv | while read -l key value
    switch $key
      case k kubeconfig
        set k_file $value
      case vidm
        set vidm true
      case h help
        echo -e $help
        return
      end
  end

  if set --query KUBECONFIG
    echo ...Using KUBECONFIG environment variable: $KUBECONFIG 1>&2
    set k_file $KUBECONFIG
  else
    echo ...Using --kubeconfig parameter: $k_file 1>&2
  end 

  # 1. Return the "server" line of the KUBECONFIG file
  # 2. Parse out the hostname (excluding whitespace)
  set -l k_host (grep "server" $k_file | sed 's|^[ \t]*server: https://\(.*\):.*$|\1|')
  echo ...The hostname associated with $k_file is: $k_host 1>&2

  if $vidm
    set -l vidm_host_line (kubectl --kubeconfig=$k_file --namespace=prelude describe deployment identity-service-app | grep VIDM_HOST)
    echo ...Found VIDM host line: $vidm_host_line 1>&2
    set -l vidm_host (kubectl --kubeconfig=/Users/tcurtis/.kube/cava-config --namespace=prelude describe deployment identity-service-app | grep VIDM_HOST | awk '{print $2}')
    echo ...Return VIDM hostname: $vidm_host 1>&2
    echo $vidm_host
  else
    echo ...Return prelude hostname: $k_host 1>&2
    echo $k_host
  end
end
