function fish_user_key_bindings
    # Alt (aka Option) + F completes single word
    bind \u0192 forward-word

    # peco (CTRL-R, ALT-R)
    bind \cr peco_select_history
    bind \u00AE peco_change_directory
end
