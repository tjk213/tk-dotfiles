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
    # Switch all screens to USB-C input (0x1b)
    # TODO: Generalize this
    #   - we should at least check to see if the current display has a usb-c connection
    #   - it would be good to parameterize so we can switch to any desired input
    for i in $(seq $num_displays); do
	ddcutil setvcp 0x60 0x1b --display $i
    done
# If we're on mac we'll use m1ddc
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Explicitly use m1ddc full path so we can register into Shortcuts,
    # which doesn't have /opt in its PATH.
    m1ddc=/opt/homebrew/bin/m1ddc

    # Switch all "non-null" screens to DisplayPort (0x0f)
    # On my modular M1 macbook, m1ddc display list shows the following:
    #
    #  [1] (null) (37D8832A-2D66-02CA-B9F7-8F30A301B230)
    #  [2] DELL U2723QE (E522360D-B4DA-4D42-87EB-C10B031FE17B)
    #  [3] DELL U2723QE (0A1F4811-4624-44B6-A9B0-8497FF53D33E)
    #
    # ...the null screen is the builtin display. We don't want to / cannot switch it
    # so we filter it out with grep.
    # TODO: Generalize this
    #   - we should at least check to see if the current display has a DP connection
    #   - it would be good to parameterize so we can switch to any desired input
    $m1ddc display list | grep -vn "null" | cut -d: -f1 | while read i; do
	$m1ddc display $i set input 15
	sleep 1 # m1ddc doesn't like operating at a high frequency for some reason.
    done
else
    echo 1>&2 "ERROR: Unexpected OS"
    exit -1
fi
