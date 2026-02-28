################################################################# -*- sh -*- #######
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

## This script is a wrapper around multi_report.sh intended for use in cronjobs.
##
## Multi-Report is an awesome NAS monitoring tool hosted here:
##  https://github.com/JoeSchmuck/Multi-Report
##

## Installation Instructions:
##
##   - Copy to the location where `multi-report` is installed on the NAS
##   - Install cronjob command: bash /full/path/to/this/script.sh

THIS_DIR=$(realpath $(dirname -- "${BASH_SOURCE[0]}"))
LOG_DIR=${HOME}/logs/multi-report
LOG_FILE="${LOG_DIR}/multi-report-$(date +%Y%m%d).log"

# cd to multi-report directory. default pwd for cronjobs is not writeable, which
# causes breakages for temporary files written to relative paths.
cd ${THIS_DIR}

# Make the log dir in case it doesn't already exist.
mkdir -p ${LOG_DIR}

# Run multi-report & log results.
bash ./multi_report.sh >> ${LOG_FILE} 2>&1
