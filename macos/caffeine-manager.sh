#!/bin/bash ########################################################################
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
##            Copyright © 2024 Tyler J. Kenney. All rights reserved.              ##
####################################################################################
####################################################################################

## caffeine-manager
##
## For some reason I cannot find any combination of settings in system preferences
## that let my screensaver play indefinitely when on AC power, and conserve energy
## when on battery. The only solution I am able to find is running caffeinate in a
## terminal, so here we have a script to check the power status and start/stop
## caffeinate accordingly.

while true; do
    caff_status=$(pgrep caffeinate)
    power_status=$(pmset -g batt | head -1)
    if [[ "${power_status}" == "Now drawing from 'AC Power'" ]] ; then
	if [[ -n "${caff_status}" ]] ; then
	    # On AC, caffeinate already running - do nothing.
	    echo "AC: Doing nothing..."
	else
	    # On AC, no caffeinate running - start it up
	    echo "AC: Caffeinating..."
	    /usr/bin/caffeinate -isd &
	fi
    elif [[ "${power_status}" == "Now drawing from 'Battery Power'" ]] ; then
	if [[ -n "${caff_status}" ]] ; then
	    # On battery, caffeinate already running - kill it.
	    for pid in ${caff_status}; do
		echo "Batt: Killing ${pid}..."
		kill -9 ${pid}
	    done
	else
	    # On battery, no caffeinate running - do nothing.
	    echo "Batt: Doing nothing..."
	fi
    else
	echo 1>&2 "CAFFEINE-MANAGER::ERROR: Failed to detect power state"
	exit -1
    fi
    sleep 600
done
