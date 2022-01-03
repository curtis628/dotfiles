function _peco_change_directory
  if test (count $argv) = 0
    set peco_flags --layout=bottom-up
  else
    set peco_flags --layout=bottom-up --query "$argv"
  end

  peco $peco_flags | read selected

  if test $selected
    cd $selected
    commandline -f repaint
  end
end

function peco_change_directory -d "Quickly change directories"
  begin
    echo $HOME/.config
    ghq list -p
    find . -type d -depth 3 -not -path '*/\.*'
  end | _peco_change_directory $argv
end
