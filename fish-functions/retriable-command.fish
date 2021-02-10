function retriable-command -d "Retries the provided command multiple times. By default, it stops after first failure."
  set -l usage "Usage:\n" \
              "    retriable-command [--count COUNT] [--output OUTPUT] [--no-exit-on-failure] [--command \"COMMAND\"]\n"
  set -l help " Retries the provided command multiple times.\n\n" \
              "Examples:\n" \
              "    #Retry maven build 5 times, outputting output and results to default ~/tmp/retriable-command\n" \
              "    retriable-command --count 5 --command \"mvn clean install\"\n\n" \
              "    #Retry specific gradle test 10 times\n" \
              "    retriable-command --count 10 --command \"./gradlew blueprint-webapp:cleanTest blueprint-webapp:test --tests BlueprintRequestControllerTest.cancelSimpleBlueprintRequestV1 --tests BlueprintRequestControllerTest.cancelSimpleBlueprintRequestV1\"\n\n" \
              "Options:\n" \
              "    --count='': The number of times to run the command. Default: -1 (until Ctrl-C)\n" \
              "    --output='': Where to output logs and status of each try. Default: ~/tmp/retriable-command\n" \
              "    --no-exit-on-failure: Continue retrying even if a command returns non-zero exit status.\n" \
              "    --command='': The command to run repeatedly\n\n" \
              "$usage"
  set -l count 20
  set -l output ~/tmp/retriable-command
  set -l command "echo Hello, world!"
  set -l prefix (date +%Y%m%d-%H%M)
  set -l exit_on_failure true

  getopts $argv | while read -l key value
    switch $key
      case count
        set count $value
      case output
        set output $value
      case command
        set command $value
      case no-exit-on-failure
        set exit_on_failure false
      case h help
        echo -e $help
        return
      end
  end

  rm -rf $output/*
  set -l output $output/$prefix
  echo Starting retriable-command with:
  echo .............count=$count
  echo ............output=$output
  echo ...exit-on-failure=$exit_on_failure
  echo .............................
  echo ...........command=$command
  mkdir -p $output

  for attempt in (seq $count)
    set -l command_status running
    echo -e \nAttempt $attempt: $command_status...
    eval time $command > $output/$attempt.log
    if test $status -eq 0
      set command_status successful
    else
      set command_status FAILED
    end
    mv $output/$attempt.log $output/$attempt.$command_status.log
    echo Attempt $attempt: $command_status

    if test $command_status = "FAILED" -a $exit_on_status
      echo Stopping retries since attempt $attempt failed
      break
    end
  end
end
