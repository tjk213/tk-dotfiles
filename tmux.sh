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
function htop-pane-height()
{
    local num_header_rows=4 # Assuming 3 rows of system info (plus blank).
    local num_cpu_rows=$(($(nproc)/2)) # Assuming 4 columns of cpu meters.
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

	#
	# Clear TMOUT variable, if its set. Modular VMs have this set by default to
	# kill shells after two hours of inactivity. This kills any idle SSH
	# connections which triggers auto-shutdown after two more hours of inactivity.
	# However, we don't want tmux panes to timeout because 1.) they won't prevent
	# auto-shutdown (the SSH connect still gets killed because the 'parent' shell
	# is still determined to be idle, even if there is a tmux session open within
	# it) and 2.) if we log back in after the SSH connection gets killed but
	# before the auto-shutdown triggers, we want to be able to re-attach to our
	# tmux session and have everything the way we left it.
	#
	# NOTE: On modular VMs, TMOUT is marked readonly. This will fail if we haven't
	#       manually updated /etc/zsh/zshrc.
	#
        tmux send-keys 'unset TMOUT' C-m
        tmux send-keys 'clear' C-m

	# Start htop pane on bottom
	tmux split-window -v
	tmux send-keys 'htop' C-m
	tmux resize-pane -y $(htop-pane-height)
	tmux last-pane
    fi

    # Attach!
    tmux attach -t $DEFAULT_SESSION
}
