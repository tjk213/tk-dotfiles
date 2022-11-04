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

# Prefix prompt with current working directory, in blue.
CURRDIR='%F{blue}%~%f'

# Set final prompt
PROMPT="${CURRDIR}${BRANCH} ${DELIM} "

