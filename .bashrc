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
alias grep='grep --color=auto'

##
## Fundamental Environment Vars
##

export EDITOR=emacs

##
## Display
##

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

##
## History
##

export HISTSIZE=-1 # no limit
export HISTCONTROL="ignorespace:ignoredups:erasedups"

shopt -s cmdhist # attempt to save all lines of a multi-line command in the same entry
shopt -s histappend # When the shell exits, append to the history file instead of overwriting it

# After each command, append to the history file.
# Use `history -c; history -r` to read all terminal history into a specific terminal.
# ${foo:+bar} is parameter expansion which evaluates to bar if foo is non-null,
# so ${PROMPT_COMMAND:+;} is adding a semicolon if and only if we need one.
export PROMPT_COMMAND="${PROMPT_COMMAND}${PROMPT_COMMAND:+;}history -a"

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

## bytes-to-gigabytes [column_number=1] [skip_first_N_lines=0]
##
##  Filter input line-by-line, converting number of bytes in given column to
##  gigabytes (er, to be precise, gibibytes (GiB)) with two decimal places
##  displayed.
##
bytes-to-gigabytes()
{
    col="$1"
    skip_lines="$2"

    if [[ $col == "" ]]; then
	col="1"
    fi

    if [[ $skip_lines == "" ]]; then
	skip_lines="0"
    fi

    awk "NR>${skip_lines} { \$${col}=sprintf(\"%.2fG\",\$${col}/1024/1024);}{ print;}"
}

export -f bytes-to-gigabytes
