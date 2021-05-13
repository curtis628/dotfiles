function klogs-dl -d "Download all k8s logs for a given label"
  set -l usage "Usage:\n" \
              "    klogs-dl [-l TAG] [-n NAMESPACE] \n"
  set -l help "Download all k8s logs for a given label.\n\n" \
              "Examples:\n"\
              "    #Download default (tango-blueprint-application-service) logs\n" \
              "    klogs-dl\n\n" \
              "    #Download provisioning-service in prelude namespace\n" \
              "    klogs-dl -l app=provisioning-service --namespace=prelude \n\n" \
              "Options:\n" \
              "    -l, --label='': Download all pods matching this k8s label\n" \
              "    -n, --namespace='': The namespace to use. If not provided, default one from kubectl config is used.\n" \
              "    -w, --wait='': Wait interval for background jobs. Default: 10\n\n" \
              "$usage"
  set -l label "app=tango-blueprint-service-app"
  set -l namespace
  set -l wait_sec 10

  getopts $argv | while read -l key value
    switch $key
      case l label
        set label $value
      case n namespace
        set namespace $value
      case w wait
        set wait_sec $value
      case h help
        echo -e $help
        return
      end
  end

  echo -e "Using KUBECONFIG=$KUBECONFIG. Parsed inputs:\n" \
          "  label: $label\n" \
          "  namespace: $namespace\n"

  set -l cmd "kubectl get pods -l $label --output=name"
  if test -n "$namespace"
    set cmd "$cmd --namespace=$namespace"
  end 

  set -l pods (eval kpn --label=$label --namespace=$namespace)
  if test (count $pods) -eq 0
    echo "klogs-dl: No pods found matching label: $label" >&2
    return 1
  end



  set cmd "kubectl logs"
  if test -n "$namespace"
    set cmd "$cmd --namespace=$namespace"
  end 
  for pod_with_prefix in $pods
    set -l pod_split (string split "/" $pod_with_prefix)
    set -l pod $pod_split[2]

    echo "...Downloading all of $pod's logs to $pod.log..."
    echo "...Running in a background process: $cmd $pod"
    eval "$cmd $pod &" > $pod.log

    echo -e "Moving onto the next pod...\n"
  end

  echo "Waiting for download jobs to complete... Run Ctrl-C to cancel"
  set -l jobs_output "initial"
  while test -n "$jobs_output"
    set jobs_output (jobs)
    echo -e "\nAs of" (date) ": Running jobs include: "
    printf "%s\n" $jobs_output
    sleep $wait_sec
  end

  echo -e "Download completed"
end
