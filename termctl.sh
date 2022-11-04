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

## Print starting control sequence for an operating system command (OSC).
##
## If we're in a tmux session, then add an additional prefix to form the
## passthrough sequence and get the command to the underlying terminal.
## This also requires that tmux's allow-passthrough option (pane level)
## is enabled (should be set in .tmux.conf).
##
function print-osc() {
    if [[ -n "$TMUX" ]]; then printf "\033Ptmux;\033"; fi; printf "\033"
}

## Print ending control sequence for OS command.
## See tmux notes on print-osc().
function print-st() {
    printf "\a"; if [[ -n "$TMUX" ]]; then printf "\033\\"; fi
}

## switch-profile <profile-name>
##
## Activate profile <profile-name> in iterm2.
##
## NB: The command code in use here (50) may be deprecated. 1337 seems to be the
##     newer version. See https://iterm2.com/documentation-escape-codes.html for
##     more details. For now, i'm leaving it as 50; if ain't broke, don't fix it.
##
function switch-profile() {
    print-osc; printf "]50;SetProfile=$1"; print-st
}

## set-title <new-title>
##
## Set terminal title to <new-title> in iterm2.
##
function set-title() {
    print-osc; printf "]0;$1"; print-st
}

## it2sp <profile>
##
## Older alias for switch-profile.
##
function it2sp {
    switch-profile $1
}
