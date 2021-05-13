function kpn -d "Return list of pod names that match to standard output"
  set -l usage "Usage:\n" \
              "    kpn [OPTIONS...] \n"
  set -l help "Return list of pod names that match to standard output.\n\n" \
              "Examples:\n"\
              "    # Return pod names for default tango-blueprint-service-app pods\n" \
              "    kpn\n\n" \
              "    # Return provisioning pod names\n" \
              "    kpn -l app=provisioning-service\n\n" \
              "OPTIONS:\n" \
              "    -l, --label='': Download all pods matching this k8s label. Default: app=tango-blueprint-service-app\n" \
              "    -n, --namespace='': The namespace to use. If not provided, default one from kubectl config is used.\n" \
              "$usage"
  set -l label "app=tango-blueprint-service-app"
  set -l namespace

  getopts $argv | while read -l key value
    switch $key
      case l label
        set label $value
      case n namespace
        set namespace $value
      case h help
        echo -e $help
        return
      end
  end

  set -l cmd "kubectl get pods -l $label --output=name"
  if test -n "$namespace"
    set cmd "$cmd --namespace=$namespace"
  end 

  echo Running command to get pod names: $cmd >&2
  set -l pods (eval $cmd)
  if test (count $pods) -eq 0
    echo "No pods found matching label: $label" >&2
    echo "  Ensure KUBECONFIG=$KUBECONFIG and namespace=$namespace is correct" >&2
    return 1
  end

  echo Found (count $pods) pods with label $label >&2
  set -l pods_no_prefix
  for pod_with_prefix in $pods
    set -l pod_split (string split "/" $pod_with_prefix)
    # Separating by new lines allows this to return array: set -l pods (kpn)
    echo $pod_split[2]
  end
end
