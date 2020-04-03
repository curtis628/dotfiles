function kpf -d "k8s port-forward for first pod that matches given label"
  if [ (count $argv) -lt 2 ]
      echo "Usage: kpf [label] [ports...]"
      return 1
  end
  set -l label $argv[1]
  set -l ports $argv[-1..2]
  set -l pod (kubectl get pods -l app=$label --no-headers | head -n 1 | awk '{print $1}')
  echo Using [label=$label] [ports=$ports]. Running: kubectl port-forward $pod $ports
  kubectl port-forward $pod $ports
end
