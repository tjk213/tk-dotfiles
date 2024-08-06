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
alias gl='git log-pretty'
alias gd='git diff'
alias ga='git add'
alias gc='git commit-checked'
alias gb='git branch-pretty'

# git clone pulls all branches by default. This is silly, so we default to --single-branch.
alias gclone='git clone --single-branch'

# git pull updates the current branch. If instead you want to switch to a different branch
# and update it from the remote, use `gfetch <branch>`. This works whether or not the local
# repo has ever heard of the new branch.
function gfetch() { git fetch origin $1 && git checkout $1 && git merge origin/$1; }

# If you want to switch to a different branch without fetching any updates, use `gswitch`.
alias gswitch='git switch'

# git push/pull update all remote tracking branches by default. This is silly, so we use
# rev-parse to find the current branch name and update only the active branch.
alias gpull-head='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias gpush-head='git push origin $(git rev-parse --abbrev-ref HEAD)'

# gpull [branch]
# Switch to <branch> if one is given and pull update from origin.
function gpull()
{
    if [[ $# -eq 0 ]]; then
	gpull-head
    elif [[ $# -eq 1 ]]; then
	gfetch $1
    else
	echo 1>&2 "ERROR: Unexpected argument(s)"
	echo 1>&2 "Usage: gpull [branch]"
	exit -1
    fi
}

# gpush [branch]
# If <branch> is given, then push it to origin.
# Otherwise, push HEAD (and only HEAD) to origin.
function gpush()
{
    if [[ $# -eq 0 ]]; then
	gpush-head
    elif [[ $# -eq 1 ]]; then
	git push origin $1:$1
    else
	echo 1>&2 "ERROR: Unexpected argument(s)"
	echo 1>&2 "Usage: gpush [branch]"
	exit -1
    fi
}

# git stash push/pop
alias gstash='git stash'
alias gpop='git stash pop'

# git submodule
alias gsub='git submodule'

# git log without viewer
alias gl1='gl -1'
alias gl2='gl -2'
alias gl3='gl -3'
alias gl4='gl -4'
alias gl5='gl -5'
alias gl6='gl -6'
alias gl7='gl -7'
alias gl8='gl -8'
alias gl9='gl -9'

# git print modified files (by position)
alias gp1="git ls-files --modified | head -1 | tail -1"
alias gp2="git ls-files --modified | head -2 | tail -1"
alias gp3="git ls-files --modified | head -3 | tail -1"
alias gp4="git ls-files --modified | head -4 | tail -1"
alias gp5="git ls-files --modified | head -5 | tail -1"
alias gp6="git ls-files --modified | head -6 | tail -1"
alias gp7="git ls-files --modified | head -7 | tail -1"
alias gp8="git ls-files --modified | head -8 | tail -1"
alias gp9="git ls-files --modified | head -9 | tail -1"

# git diff files by position
alias gd1='git diff $(gp1)'
alias gd2='git diff $(gp2)'
alias gd3='git diff $(gp3)'
alias gd4='git diff $(gp4)'
alias gd5='git diff $(gp5)'
alias gd6='git diff $(gp6)'
alias gd7='git diff $(gp7)'
alias gd8='git diff $(gp8)'
alias gd9='git diff $(gp9)'

# git add files by position
alias ga1='git add $(gp1)'
alias ga2='git add $(gp2)'
alias ga3='git add $(gp3)'
alias ga4='git add $(gp4)'
alias ga5='git add $(gp5)'
alias ga6='git add $(gp6)'
alias ga7='git add $(gp7)'
alias ga8='git add $(gp8)'
alias ga9='git add $(gp9)'

# git diff/add top modified file
alias gdt='gd1'
alias gat='ga1'

alias is-git-repo='git rev-parse --is-inside-work-tree &>/dev/null'
alias get-git-branch='is-git-repo && git branch --show-current'

# gbackup [branch]
# Create a branch called B-backup-X where B is either <branch> or the current
# branch, and X is the lowest positive integer that doesn't already exist.
function gbackup()
{
    if [[ $# -eq 0 ]]; then
	branch=$(git rev-parse --abbrev-ref HEAD)
    elif [[ $# -eq 1 ]]; then
	branch=$1
    else
	echo 1>&2 "ERROR: Unexpected argument(s)"
	echo 1>&2 "Usage: gbackup [branch]"
	exit -1
    fi

    i=1
    while git show-ref --quiet refs/heads/${branch}-backup-${i}; do
	i=$((i+1))
    done
    git branch ${branch}-backup-${i}
}

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
