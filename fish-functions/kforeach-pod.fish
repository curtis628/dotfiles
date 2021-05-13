function kforeach-pod -d "Run the given command in each matching pod"
  set -l usage "Usage:\n" \
              "    kforeach-pod [OPTIONS...] COMMAND\n"
  set -l help "Run the given command in each matching pod.\n\n" \
              "Examples:\n"\
              "    # Run 'ps -aux' asynchronously in each pod, storing output to file\n" \
              "    kforeach-pod \"ps -aux\" --name=ps-aux\n\n" \
              "    # Create a heap dump on each provisioning pod\n" \
              "    kforeach-pod -l app=provisioning-service --namespace=prelude \"jcmd 1 GC.heap_dump /var/log/heapdump.hprof\"\n\n" \
              "OPTIONS:\n" \
              "    -l, --label='': Download all pods matching this k8s label. Default: app=tango-blueprint-service-app\n" \
              "    -p, --pods='': Use provided pod names instead of discovering them.\n" \
              "    -n, --namespace='': The namespace to use. If not provided, default one from kubectl config is used.\n" \
              "    -c, --name='': User-friendly name for the command. If provided, command will run in background, and output stored in a file referencing this name.\n" \
              "    -a, --async='': Force command to run in the background (even if --name not provided). Default: False\n" \
              "    -w, --wait='': Wait interval for background jobs. Default: 5\n" \
              "COMMAND: The command to run in each pod. Ex: "ps -aux"\n\n" \
              "$usage"
  set -l label "app=tango-blueprint-service-app"
  set -l namespace
  set -l pods
  set -l command
  set -l commmand_name
  set -l async false
  set -l wait_sec 5

  getopts $argv | while read -l key value
    switch $key
      case _
        set command $command $value
      case l label
        set label $value
      case n namespace
        set namespace $value
      case p pods
        set pods $pods $value
      case c name
        set command_name $value
      case a async
        set async $value
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
            "  pods: $pods\n" \
            "  command: $command\n" \
            "  command_name: $command_name\n" \
            "  async: $async\n" >&2
    set pods (eval kpn --label=$label --namespace=$namespace)
  end
  if test (count $pods) -eq 0
    echo "kforeach-pod: No pods found matching label: $label" >&2
    return 1
  end

  set exec_cmd "kubectl exec -t"
  if test -n "$namespace"
    set exec_cmd "$exec_cmd --namespace=$namespace"
  end 
  for pod in $pods
    echo -e "\n...Running in $pod: $command"
    set -l outfile /dev/null

    if test -n "$command_name"
      set outfile "$pod.$command_name.log"
    end

    if test -n "$command_name"
      or test "$async" = "true"
      echo -e "......Running in background -> $outfile"
      eval "$exec_cmd $pod -- $command &" > $outfile
    else
      eval "$exec_cmd $pod -- $command"
    end 
  end

  if test -n "$command_name"
    or test "$async" = "true"
    wait-background --check $wait_sec
  end

  echo -e \nSuccessfully ran on all (count $pods) pods: $command
end
