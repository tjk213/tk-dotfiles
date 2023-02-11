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

TOP="${0:A:h}"

source ${TOP}/coreutils.sh
source ${TOP}/history.sh
source ${TOP}/termctl.sh
source ${TOP}/tmux.sh
source ${TOP}/ps.sh

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
##   automate installation, but I'm using the manual process for now. This means
##   the source command below will fail on a new machine if we haven't yet cloned
##   the fork.
##

source $HOME/apps/zsh-fsh/fast-syntax-highlighting.plugin.zsh

##
## Format time builtin.
##
## NB: The builtin can be disabled with `disable -r time`, which should cause
## fallback to /usr/bin/time.
##

TIMEFMT=$'\nCPU Utilization: %P\n\nCPU Time (user): %U\nCPU Time  (sys): %S\n\nTotal Time: %E\n'

# Run color-test from termctl.sh to kick off new shell.
color-test
