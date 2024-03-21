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

    #
    # Add conda packages
    #
    # This was added only for jupyter-lab, which is used for dynamic graphviz
    # rendering. All's that really matters here is that when starting the
    # jupyter server, its the conda-based jupyter-lab binary that gets run.
    # Clearly, there are other ways to do this - this is a big hammer. But for
    # now we just add everything in anaconda onto our PATH.
    #
    # NB: For the graphviz plugin, see:
    #    https://github.com/deathbeds/jupyterlab_graphviz
    #
    PATH=/opt/homebrew/anaconda3/bin:$PATH
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
alias backup="${TKD}/core/backup.py"

##
## Git aliases
##

alias gs='git status'
alias gl='git log-pretty -36'
alias gd='git diff'
alias ga='git add'
alias gc='git commit-checked'
alias gb='git branch-pretty'

# git print modified files (by position)
alias gp1="git ls-files --modified | head -1 | tail -1"
alias gp2="git ls-files --modified | head -2 | tail -1"
alias gp3="git ls-files --modified | head -3 | tail -1"
alias gp4="git ls-files --modified | head -4 | tail -1"

# git diff files by position
alias gd1='git diff $(gp1)'
alias gd2='git diff $(gp2)'
alias gd3='git diff $(gp3)'
alias gd4='git diff $(gp4)'

# git add files by position
alias ga1='git add $(gp1)'
alias ga2='git add $(gp2)'
alias ga3='git add $(gp3)'
alias ga4='git add $(gp4)'

# git diff/add top modified file
alias gdt='gd1'
alias gat='ga1'

alias is-git-repo='git rev-parse --is-inside-work-tree &>/dev/null'
alias get-git-branch='is-git-repo && git branch --show-current'

##
## Copy/paste aliases
## Usage:
##    % echo 'foobar' | copy
##    % copy < file
##    % <paste with ctrl/cmd-v anywhere>
##    % paste | grep baz > file2
##

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    alias copy='pbcopy'
    alias paste='pbpaste'
else # Assuming linux
    alias copy='xclip -sel clip'
    alias paste='xclip -sel clip -o'
fi

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
## If we're on mac, then everything is Apple clang and we want to leave that alone.
## Otherwise, prefer clang over gcc.
if [[ "$OSTYPE" != "darwin"* ]]; then
    export CC=clang
    export CXX=clang++
fi
export CCACHE_CONFIGPATH="${TKD}/toolchain/ccache.conf"

##
## Directory Shortcuts
##

export A=$HOME/apps
export B=$HOME/backups
export D=$HOME/Downloads
export W=$HOME/workspace

##
## Prompt Commands
##

function set-GB() {
    export GB=$(get-git-branch)
}

if [[ -n "$BASH_VERSION" ]]; then
    SEMICOLON_IF_NEEDED="${PROMPT_COMMAND:+;}"
    export PROMPT_COMMAND="${PROMPT_COMMAND}${SEMICOLON_IF_NEEDED}set-GB"
elif [[ -n "$ZSH_VERSION" ]]; then
    precmd_functions+=(set-GB)
fi

##
## Python
##

if [[ -z $DEFAULT_PYTHON_VERSION ]] ; then
    export DEFAULT_PYTHON_VERSION=3.10
fi

# Activate python venv if we don't already have one.
# If this environ variable proves unreliable, we could also use:
# python -c 'import sys; print ("1" if hasattr(sys, "real_prefix") else "0")'
#
# See: stackoverflow.com/questions/15454174/
#     how-can-a-shell-function-know-if-it-is-running-within-a-virtualenv
if [[ -z "$VIRTUAL_ENV" ]] ; then
    source $HOME/venvs/py-${DEFAULT_PYTHON_VERSION}/bin/activate
fi
