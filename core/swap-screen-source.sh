#!/bin/bash
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
##            Copyright © 2026 Tyler J. Kenney. All rights reserved.              ##
####################################################################################
####################################################################################

# If we're on linux we'll use ddcutil
if [[ "$OSTYPE" == "linux"* ]]; then
    # Get number of displays
    num_displays=$(ddcutil detect --brief | grep Display | wc -l)
    # Switch to USB-C input (0x1b)
    # TODO: Generalize this - currently hardcoded to switch to usb-c.
    for i in $(seq $num_displays); do
	ddcutil setvcp 0x60 0x1b --display $i
    done
# If we're on mac we'll use m1ddc
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Get number of displays
    num_displays=$(m1ddc display list | wc -l)
    # Switch to DisplayPort (0x0f)
    # TODO: Generalize this - currently hardcoded to switch to display-port
    for i in $(seq $num_displays); do
	m1ddc display $i set input 15
    done
else
    echo 1>&2 "ERROR: Unexpected OS"
    exit -1
fi
