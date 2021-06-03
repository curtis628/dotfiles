function mmkdir -d "mkdir + cd bundled into a single, handy command."
  set -l usage "Usage:\n" \
              "    mmkdir [directory_name] \n"
  set -l help " 'mkdir' + 'cd' bundled into a single, handy command!\n\n" \
              "$usage\n" \
              "Examples:\n" \
              "    # Create new 'test' directory, and then cd into it automatically.\n" \
              "    mmkdir test\n\n" \
              "    # Create and 'cd' into default new directory: YYYYMMdd\n" \
              "    mmkdir\n\n" \
              "Arguments:\n" \
              "    directory_name: The name of the directory to create and change into. Default: YYYYMMdd"
  set -l folder_name (date "+%Y%m%d")
  getopts $argv | while read -l key value
    switch $key
      case _
        set folder_name $value
      case h help
        echo -e $help
        return
      end
  end

  mkdir $folder_name
  cd $folder_name
end
