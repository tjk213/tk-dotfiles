####################################################################################
##               ,:                                                         ,:    ##
##             ,' |                                                       ,' |    ##
##            /   :                                                      /   :    ##
##         --'   /       :::::::::::   :::::::::::   :::    :::       --'   /     ##
##         \/ />/           :+:            :+:       :+:   :+:        \/ />/      ##
##         / /_\           +:+            +:+       +:+  +:+          / /_\       ##
##      __/   /           +#+            +#+       +#++:++         __/   /        ##
##      )'-. /           +#+            +#+       +#+  +#+         )'-. /         ##
##      ./  :\          #+#        #+# #+#       #+#   #+#         ./  :\         ##
##       /.' '         ###         #####        ###    ###          /.' '         ##
##     '/'                                                        '/'             ##
##     +                                                          +               ##
##    '                                                          '                ##
####################################################################################
##            Copyright © 2022 Tyler J. Kenney. All rights reserved.              ##
####################################################################################
####################################################################################

export HISTSIZE=$((10*1000*1000)) # NB: Negatives don't work on MacOS

if [[ -n "$BASH_VERSION" ]]; then
    export HISTCONTROL="ignorespace:ignoredups:erasedups"
    shopt -s cmdhist # attempt to save all lines of a multi-line command in the same entry
    shopt -s histappend # When the shell exits, append to the history file instead of overwriting it

    # After each command, append to the history file.
    # Use `history -c; history -r` to read all terminal history into a specific terminal.
    # ${foo:+bar} is parameter expansion which evaluates to bar if foo is non-null,
    # so ${PROMPT_COMMAND:+;} is adding a semicolon if and only if we need one.
    export PROMPT_COMMAND="${PROMPT_COMMAND}${PROMPT_COMMAND:+;}history -a"
elif [[ -n "$ZSH_VERSION" ]]; then
    setopt INC_APPEND_HISTORY # Immediately append to history after each command
    setopt HIST_FIND_NO_DUPS  # Ignore duplicates when searching history
else
    echo "history.sh: Unexpected shell!"
fi
