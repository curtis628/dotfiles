function kcp-foreach-pod -d "Copy a given file from each matching pod"
  set -l usage "Usage:\n" \
              "    kcp-foreach-pod [OPTIONS...] PODPATH\n"
  set -l help "Copy a given file from each matching pod.\n\n" \
              "Examples:\n"\
              "    # Copy the provided heap dump from each pod to the current local directory.\n" \
              "    kcp-foreach-pod /var/log/heaps/heapdump.hprof" \
              "OPTIONS:\n" \
              "    -l, --label='': Download all pods matching this k8s label. Default: app=tango-blueprint-service-app\n" \
              "    -n, --namespace='': The namespace to use. If not provided, default one from kubectl config is used.\n" \
              "    -p, --pods='': Use provided pod names instead of discovering them.\n" \
              "    -f, --file='': The local filename to use.\n" \
              "    -w, --wait='': Wait interval for background jobs. Default: 10\n" \
              "PODPATH: The file path to copy from within the pod.\n\n" \
              "$usage"
  set -l label "app=tango-blueprint-service-app"
  set -l namespace
  set -l pods
  set -l podpath
  set -l localfile
  set -l wait_sec 10

  getopts $argv | while read -l key value
    switch $key
      case _
        set podpath $podpath $value
      case l label
        set label $value
      case n namespace
        set namespace $value
      case p pods
        set pods $pods $value
      case f file
        set localfile $value
      case w wait
        set wait_sec $value
      case h help
        echo -e $help
        return
      end
  end

  if test -z "$pods"
    echo -e "Using KUBECONFIG=$KUBECONFIG:\n" \
            "  label: $label\n" \
            "  namespace: $namespace\n" \
            "  podpath: $podpath\n" \
            "  localfile: $localfile" >&2
    set pods (eval kpn --label=$label --namespace=$namespace)
  end
  if test (count $pods) -eq 0
    echo "kcp-foreach-pod: No pods found matching label: $label" >&2
    return 1
  end

  set exec_cmd "kubectl cp"
  if test -n "$namespace"
    set exec_cmd "$exec_cmd --namespace=$namespace"
  end 
  for pod in $pods
    set -l outfile "$pod.$localfile"
    echo "...Copying from $pod:$podpath to $outfile"
    eval "$exec_cmd $pod:$podpath $outfile &"
  end
  wait-background --check $wait_sec

  echo -e \nSuccessfully ran \"$command\" on all (count $pods) pods
end
