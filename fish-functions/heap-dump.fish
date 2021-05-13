function heap-dump -d "Automates the process of generating and download heap dumps across all matching pods"
  set -l usage "Usage:\n" \
              "    heap-dump [OPTIONS...] \n"
  set -l help "Automates the process of generating and download heap dumps across all matching pods.\n\n" \
              "Examples:\n"\
              "    # Generate and download heap dumps for all default (tango-blueprint-service-app) pods\n" \
              "    heap-dump\n\n" \
              "    # Generate and download heap dumps provisioning pods\n" \
              "    heap-dump -l app=provisioning-service --namespace=prelude\n\n" \
              "OPTIONS:\n" \
              "    -l, --label='': Download all pods matching this k8s label. Default: app=tango-blueprint-service-app\n" \
              "    -n, --namespace='': The namespace to use. If not provided, default one from kubectl config is used.\n" \
              "    -p, --dump-path='': The path to use for each pod's heap dump. Default: /var/log/heaps\n" \
              "    -f, --dump-name='': The filename to use for each pod's heap dump.\n" \
              "    -k, --keep='': Keep the heap dump on the pod instead of cleaning it up.\n" \
              "COMMAND: The command to run in each pod. Ex: "ps -aux"\n\n" \
              "$usage"
  set -l label "app=tango-blueprint-service-app"
  set -l namespace
  set -l dump_path /var/log/heaps
  set -l dump_name heapdump.hprof
  set -l keep false

  getopts $argv | while read -l key value
    switch $key
      case _
        set command $command $value
      case l label
        set label $value
      case n namespace
        set namespace $value
      case p dump-path
        set dump_path $value
      case f dump-name
        set dump_name $value
      case h help
        echo -e $help
        return
      end
  end

  set -l pods (eval kpn --label=$label --namespace=$namespace)
  if test (count $pods) -eq 0
    echo "heap-dump: No pods found matching label: $label" >&2
    return 1
  end
  echo -e "Generating heap-dump using KUBECONFIG=$KUBECONFIG:\n" \
          "  label: $label\n" \
          "  namespace: $namespace\n" \
          "  pods: $pods\n" \
          "  dump_path: $dump_path\n" \
          "  keep: $keep\n" \
          "  dump_name: $dump_name\n" >&2

  kforeach-pod    --pods=$pods --name=ps-aux -- ps -aux
  kforeach-pod    --pods=$pods --async       -- mkdir -p $dump_path
  kforeach-pod    --pods=$pods --async       -- jcmd 1 GC.heap_dump $dump_path/$dump_name
  kforeach-pod    --pods=$pods --async -w10  -- gzip $dump_path/$dump_name
  kcp-foreach-pod --pods=$pods --async --file=$dump_name.gz $dump_path/$dump_name.gz
  if test "$keep" = "false"
    kforeach-pod    --pods=$pods --async       -- rm $dump_path/$dump_name.gz
  end
  gunzip $pods.$dump_name.hprof.gz

  echo -e \nSuccessfully retrieved heap dumps on all (count $pods) pods
end
