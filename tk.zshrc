################################################################# -*- sh -*- #######
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

export TKD="${0:A:h}"

source ${TKD}/core/coreutils.sh
source ${TKD}/core/history.sh
source ${TKD}/core/ps.sh
source ${TKD}/stat/stat.sh
source ${TKD}/term/termctl.sh
source ${TKD}/term/tmux.sh
source ${TKD}/modular/modular.sh

##
## Customize shell prompt
##

setopt PROMPT_SUBST

# Carrot delimiter, colored by prev command exit status.
DELIM='%(?.%F{green}.%F{red})❯%f'

# Load git info and prefix prompt with [git-branch] in red.
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' [%b]'
BRANCH='%F{red}${vcs_info_msg_0_}%f'

# Prefix prompt with basename of current working directory, in blue.
# See `man zshmisc` EXPANSION OF PROMPT SEQUENCES section for details.
# TODO: Should we get some underlines and/or bolds going??
CURRDIR='%F{blue}%1~%f'

# Set final prompt
PROMPT="${CURRDIR}${BRANCH} ${DELIM} "

##
## Standard zshell options
##

setopt NO_BEEP      # Disable beeping
#setopt CD_ABLE_VARS # Transform cd x -> cd $x if x is not a dir & is a parameter.

typeset -U PATH path # Unique-ify path
export -TU LD_LIBRARY_PATH ld_library_path # link array to var & unique-ify

##
## Tab completion
##

autoload -Uz compinit; compinit

# Disable autocomplete cycling on ambiguous complete; just list like bash
setopt NO_AUTO_MENU

# Tab complete regardless of trailing whitespace (only prefix matters), like bash.
bindkey '\CI' expand-or-complete-prefix

# Tab complete on long-args with --foobar=/path/to/my/file
function tab-complete-equals() {
    compset -P '*='
    _default -r '\-\n\t /=' "$@"
}
compdef tab-complete-equals -first-

##
## Enable zsh fast-syntax-highlighting
##
##  NB: The syntax highlighting in general here is great but the main feature I
##   was looking for when I set this up is git-commit-message-length-highlighting.
##   This appears to have been dropped after v1.5, and also defaulted to the wrong
##   character threshold. As a result, I made my own fork to resolve these issues:
##
##     https://github.com/tjk213/zsh-fsh
##
##   The FSH readme suggests a few different zsh plugins that could potentially
##   automate installation, but I'm using git submodule for now. So make sure to
##   clone this repo with submodules included!
##

source $TKD/third-party/zsh-fsh/fast-syntax-highlighting.plugin.zsh

##
## Format time builtin.
##
## NB: The builtin can be disabled with `disable -r time`, which should cause
## fallback to /usr/bin/time.
##

export REPORTTIME=20
export TIMEFMT="${fg[magenta]}Time Elapsed: %*U user - %*S system - %*E real"

# Run color-test from termctl.sh to kick off new shell.
color-test
