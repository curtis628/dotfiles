function kpf -d "k8s port-forward utility for the first pod that matches the given label"
  set -l usage "Usage:\n" \
              "    kpf [--label LABEL] [LOCAL_PORT:]REMOTE_PORT [...[LOCAL_PORT_N:]REMOTE_PORT_N]\n"
  set -l help " k8s port-forward for the first pod that matches the given label.\n\n"\
              "Examples:\n"\
              "    # port-forward postgres (default 'label') using pod's port of 5432 and localhost port of 7000.\n" \
              "    kpf 7000:5432\n" \
              "\n" \
              "    # port-forward postgres explicitly, 5432 for both pod's port and localhost port.\n" \
              "    kpf --label app=postgres 5432\n\n" \
              "Options:\n" \
              "    -l, --label='': The k8s label. Default: app=postgres\n\n" \
              "$usage"
  set -l label "app=postgres"
  set -l ports

  getopts $argv | while read -l key value
    switch $key
      case _
        set ports $value
      case l label
        set label $value
      case h help
        echo -e $help >&2
        return
      end
  end
  set -l pod (kubectl get pods -l $label --no-headers | head -n 1 | awk '{print $1}')
  echo Using [label=$label] [ports=$ports]. Running: kubectl port-forward $pod $ports >&2
  kubectl port-forward $pod $ports
end
