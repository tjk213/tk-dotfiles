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

## bytes-to-gigabytes [column_number=1] [skip_first_N_lines=0]
##
##  Filter input line-by-line, converting number of bytes in given column to
##  gigabytes (er, to be precise, gibibytes (GiB)) with two decimal places
##  displayed.
##
bytes-to-gigabytes()
{
    col="$1"
    skip_lines="$2"

    if [[ $col == "" ]]; then
	col="1"
    fi

    if [[ $skip_lines == "" ]]; then
	skip_lines="0"
    fi

    awk "NR>${skip_lines} { \$${col}=sprintf(\"%.2fG\",\$${col}/1024/1024/1024);}{ print;}"
}

export -f bytes-to-gigabytes

## psmem [--skip-headers] [extra_ps_options]
##
## Display memory status of given processes in GiB.
##
##   - pid:   Process ID
##   - user:  Process owner
##   - vsize: Total allocated virtual memory
##   - rss:   Physical RAM in active use (Resident Set Size)
##   - pmem:  rss divided by total installed physical memory
##   - comm:  Executable name (use `command` or `args` for executable + args)
##
## See `man ps` for process selection guide.
##
psmem()
{
    if [[ $1 == "--skip-headers" ]]; then
	skips=0
	headers="--no-headers"
	shift
    else
	skips=1
	headers="--headers"
    fi

    ps -o pid,user,vsize,rss,pmem,comm ${headers} "$@" | bytes-to-gigabytes 3 ${skips} | bytes-to-gigabytes 4 ${skips} | column -t
}

export -f psmem

## psmem-log [extra_ps_options]
##
## Repeatedly call `psmem` and append results to stdout.
##
## TODO: Add option to set sampling rate
##
## TODO: Detect end condition?
##
## TODO: Can we replace this with a CLI on psmem? Something like psmem --log=5m ?
##
psmem-log()
{
    psmem "$@"
    while sleep 1; do
	psmem --skip-headers "$@";
    done
}

export -f psmem-log
