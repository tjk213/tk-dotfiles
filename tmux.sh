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

# Attach to session "default" if it exists.
# Otherwise, create it and attach.
function tmux-default()
{
    DEFAULT_SESSION="default"
    tmux has-session -t $DEFAULT_SESSION &> /dev/null

    if [[ $? != 0 ]] ; then
	# x & y set the width & height of the session, which otherwise is uninferred
	# until the session is first attached. This is necessary for resizing panes
	# below to work correctly.
	tmux new-session -ds $DEFAULT_SESSION -x $COLUMNS -y $LINES

	# Start htop pane on bottom
	tmux split-window -v
	tmux send-keys 'htop' C-m
	tmux resize-pane -y 11 # Assuming 4 rows of CPU meters, shows 0 processes
	tmux last-pane
    fi

    # Attach!
    tmux attach -t $DEFAULT_SESSION
}
