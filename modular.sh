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
##            Copyright © 2023 Tyler J. Kenney. All rights reserved.              ##
####################################################################################
####################################################################################

##
## Directory Shortcuts
##

export M=$HOME/workspace/modular
export I=$HOME/workspace/infra
export R=$HOME/workspace/recommenders
export F=$HOME/workspace/ferrari-models

##
## Python
##

DISABLE_CHDIR=1 source $M/utils/start-modular.sh
unset -f model

##
## Tracefiles
##
##  sort-X and filter-X commands preserve top-level entries like versionInfo.
##  select-X and list-X commands do not.
##

alias sort-trace="jq '.traceEvents |= sort_by(.ts)'"
alias filter-llcl="jq 'del(.traceEvents[] | select(.name|startswith(\"llcl\")))'"
alias select-runs="jq '.traceEvents[] | select(.name==\"runModelOnce\")'"

## NB: list-runs works in pipe-format only (e.g., cat trace.json | list-runs); does
##     not work in command-format (e.g. list-runs trace.json). This is due to the
##     pipes. Should we switch this to a function so we can enable command-format?
##     Bail on the sort? Mash it all into one jq command instead of modularity?
##
## NB: Sorting the trace could be slow for big models. We could flip this around
##     and filter first if necessary.
alias list-runs="sort-trace | select-runs | jq -c '{name, ts, dur}'"

##
## VM IPs
##

function get-mdcm-vm-ip() { cd $I && echo $(mdcm vm list -n $1 -ip) && cd $OLDPWD; }
function AMD()  { echo $(get-mdcm-vm-ip amd-22.04); }
function GRAV() { echo $(get-mdcm-vm-ip grav-22.04); }
function INTEL() { echo $(get-mdcm-vm-ip x86-22.04); }
function INTEL-12XL() { echo $(get-mdcm-vm-ip x86-c5-12xlarge); }

if [[ -f "modular-local.sh" ]] ; then
    source modular-local.sh
fi
