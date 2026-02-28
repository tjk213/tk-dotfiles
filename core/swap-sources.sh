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

LOG_FILE=/tmp/swap-sources.log

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$LOG_FILE"
}

run_logged() {
    # First argument is index used only for logging
    local display=$1
    shift
    # Remaining args get executed
    local output status
    output=$("$@" 2>&1)
    status=$?
    log "display: $display exit: $status output: $output"
    return $status
}

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
    #
    # TODO: Generalize this
    #   - we should at least check to see if the current display has a DP connection
    #   - it would be good to parameterize so we can switch to any desired input
    #
    # NOTE: On my modular M1 macbook, the first display is often printing errors
    # about a "DDC communication failure" and returning non-zero, even though the
    # display switches as desired. Presumably, this means that m1ddc is trying to
    # read back the results for verification, but that's failing because the monitor
    # is already gone. ddcutil actually has switches to disable verification, but no
    # such thing available with m1ddc. To keep an eye on this, we log output & exit
    # codes to the log file.
    #
    # NOTE: the act of switching the inputs seems to cause macos/m1ddc to re-enumerate
    # the remaining monitors, at least temporarily. Or, that's the theory anyway. I've
    # tried watching `m1ddc display list` and it never shows any changes, but changing
    # display 2 before display 3, for example, does seem to cause display 3 to fail
    # sometimes. For this reason, we add a pipe through `tail -r` so we switch the displays
    # from highest ID to lowest.
    #
    # NOTE: Tried registering the keyboard shortcut via builtin "Shortcuts" app but it was
    # a nightmare. It would work ok when Shortcuts was in focus; lots of issues otherwise.
    # Eventually switched to Raycast; working well enough so far.
    #
    $m1ddc display list | grep -vn "null" | cut -d: -f1 | tail -r | while read i; do
	run_logged $i $m1ddc display $i set input 15
	sleep 0.1 # m1ddc doesn't like operating at a high frequency for some reason.
    done
else
    echo 1>&2 "ERROR: Unexpected OS"
    exit -1
fi
