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

##
## PATH
##
## Some of these make use of GNU coreutils - see setup_macos.sh
##

if [[ "$OSTYPE" == "darwin"* ]]; then
    PATH=/opt/homebrew/opt/util-linux/bin:$PATH
fi

##
## Fundamental aliases
##
## Some of these make use of GNU coreutils - see setup_macos.sh
##

if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='gls'
    alias rgrep='grep -r --line-number --binary-files=without-match --color=auto'
fi

## ll - list directory
##
##   -l: list details
##   -h: human-readable
##   -B: hide editor backups like .bashrc~ (GNU ls only)
##   -v: natural sort (handles things like version numbers)
##
alias ll='ls -lhBv --group-directories-first --color=auto'

alias e='emacs'
alias python='python3'
alias grep='grep --color=auto'
alias gs='git status'

## Overide TERM in emacs environment
##
## On most modern emulators, TERM defaults to xterm-256colors. But within tmux,
## TERM is typically set to screen-256colors. This difference causes emacs28 to
## incorrectly detect a dark background, and flips the syntax highlighgting color
## scheme. We use an emacs alias to explicitly override TERM for emacs so we can
## open files in tmux and they look the same as non-tmux.
##
## You can test the color difference between emacs' dark & light backgrounds with:
##
##  - emacs -Q -nw --eval "(setq frame-background-mode 'dark)"
##  - emacs -Q -nw --eval "(setq frame-background-mode 'light)"
##
## This is a bit of a hack; it would be better to fix emacs so it doesn't mistake
## tmux for a dark background, but not sure how to do that at this point. One
## possibility seems to be using term-file-aliases to set screen-256color as an
## alias for xterm-256 color in emac's eyes, but I can't get this working for some
## reason. There's a good discussion in this stack overflow link:
##
##  stackoverflow.com/questions/7617458/terminal-emacs-colors-only-work-with-term-xterm-256color
##
alias emacs='TERM=xterm-256color emacs'

##
## Fundamental Environment Vars
##

export EDITOR=emacs

##
## Directory Shortcuts (modular)
##

export M=$HOME/workspace/modular
export I=$HOME/workspace/infra
export R=$HOME/workspace/recommenders

##
## Tracefiles
##
##  sort-X and filter-X commands preserve top-level entries like versionInfo.
##  select-X and list-X commands do not.
##

alias sort-trace="jq '.traceEvents |= sort_by(.ts)'"
alias filter-llcl="jq 'del(.traceEvents[] | select(.name|startswith(\"llcl\")))'"
alias select-runs="jq '.traceEvents[] | select(.name==\"runModelOnce\")'"

## NB: list-runs works in pipe-format only (e.g., cat trace.json | list-runs); does
##     not work in command-format (e.g. list-runs trace.json). This is due to the
##     pipes. Should we switch this to a function so we can enable command-format?
##     Bail on the sort? Mash it all into one jq command instead of modularity?
##
## NB: Sorting the trace could be slow for big models. We could flip this around
##     and filter first if necessary.
alias list-runs="sort-trace | select-runs | jq -c '{name, ts, dur}'"
