function retriable-command -d "Continuously retries the provided command. Stop with Ctrl-C"
  if [ (count $argv) -lt 1 ]
      echo "Usage: retriable-command [cmd]"
      return 1
  end
  set -l cmd $argv[1]
  echo "Will retry this command until a Ctrl-C: $cmd"
  set -l ndx 1
  while true
    echo \nAttempt \#$ndx
    eval $cmd
    sleep 15
    set -l ndx (math $ndx + 1)
  end
end
