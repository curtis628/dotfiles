function wait-background -d "Waits for background tasks to finish"
  set -l usage "Usage:\n" \
              "    wait-background [OPTIONS...] \n"
  set -l help "Waits for background tasks to finish.\n\n" \
              "Examples:\n"\
              "    # Wait for background tasks, checking status at default interval.\n" \
              "    wait-background\n\n" \
              "    # Wait for background tasks, checking status every 10 seconds.\n" \
              "    wait-background --check 5\n\n" \
              "OPTIONS:\n" \
              "    -c, --check='': Interval (in secs) for checking status of background tasks. Default: 5\n" \
              "$usage"
  set -l interval_sec 5

  getopts $argv | while read -l key value
    switch $key
      case c check
        set interval_sec $value
      case h help
        echo -e $help
        return
      end
  end

  echo -e "\nWaiting for background jobs to complete, checking every $interval_sec seconds... Run Ctrl-C to cancel"
  set -l jobs_output (jobs)
  while test -n "$jobs_output"
    printf "\nAs of %s: Running jobs include:\n" (date)
    printf "%s\n" $jobs_output
    sleep $interval_sec
    set jobs_output (jobs)
  end
end
