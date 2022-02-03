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

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

##
## Fundamental aliases
##
## Some of these make use of GNU coreutils - see setup_macos.sh
##

if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='gls'
    alias rgrep='ggrep -r --line-number --binary-files=without-match --color=auto'
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

##
## Fundamental Environment Vars
##

export EDITOR=emacs

##
## Functions
##

## it2sp <profile>
##
## Activate profile <profile> in iTerm2.
##
function it2sp {
    echo -e "\033]50;SetProfile=$1\a"
}
