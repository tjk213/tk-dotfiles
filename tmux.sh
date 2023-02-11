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

function tmux-default()
{
    # Start default session
    #
    # x & y set the width & height of the session, which otherwise is uninferred
    # until the session is first attached. This is necessary for resizing panes
    # below to work correctly.
    tmux new-session -ds 'default' -x $COLUMNS -y $LINES

    # Start htop pane on bottom
    tmux split-window -v
    tmux send-keys 'htop' C-m
    tmux resize-pane -y 11 # Assuming 4 rows of CPU meters, should show 0 processes
    tmux last-pane

    # Attach!
    tmux attach -t 'default'
}
