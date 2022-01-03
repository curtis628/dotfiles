function peco_select_history -d "Use history+peco to find and run historical command"
  if test (count $argv) = 0
    set peco_flags --layout=bottom-up
  else
    set peco_flags --layout=bottom-up --query "$argv"
  end

  history | peco $peco_flags | read selected

  if string length $selected > 0
    commandline $selected
  else
    commandline ''
  end
end
