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

# Return the height we want for our htop pane.
# This is a function of the # of cores in the system, as well as the htop config.
function htop-meter-height()
{
    local num_header_rows=4 # Assuming 3 rows of system info (plus blank).
    local num_cpu_rows=$(($(nproc)/8)) # Assuming 8 columns of cpu meters.
    local num_trailing_rows=2
    echo $(($num_header_rows+$num_cpu_rows+$num_trailing_rows))
}

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
	tmux resize-pane -y $(htop-meter-height)
	tmux last-pane
    fi

    # Attach!
    tmux attach -t $DEFAULT_SESSION
}
