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

# Return the # of columns of CPU meters we want in htop
function htop-num-cpu-cols()
{
    # Note: nproc --all includes all hardware cpus in the system, whether they are
    # online, offline, or online-but-disabled-through-cgroups.
    # nproc without --all returns only CPUs available for actual processing, which
    # means they are not only online but also have not been disabled through cgroups.
    #
    # This distinction has become relevant in Modular coder VMs because under the hood
    # they are docker containers that have been launched with --cpuset-cpus to reduce
    # core counts available to each user.
    #
    # The full set of hardware cores can be seen through `lscpu`.
    # The list of online cores is available via sysfs: /sys/devices/system/cpu/online
    # The list of enabled cores can be seen as a mask with: `taskset -p $$`
    #
    # Unfortunately, htop does not check the cgroups affinity mask when choosing how
    # many cores to display. Instead it simply displays all online cpus, which means
    # we need to size the window for all online cpus. Use of nproc --all sizes the
    # window for all cpus whether online or offline, but in practice I don't have any
    # systems with a significant number of offline cpus so that is ok for now.
    #
    # In order to have htop ignore disabled cores, I think there are two solutions:
    #
    #  - Update htop to check cgroup affinity mask
    #  - Update container env such that sysfs reflects only enabled cores
    #
    # The first solution would be an htop patch; perhaps we should file an issue.
    # It looks like LXCFS could be installed in order to implement the second
    # solution: https://github.com/lxc/lxcfs
    #
    # There is an RFD from 2021 for the linux kernel to build a native solution, but
    # it looks like it went nowhere:
    #
    # https://lore.kernel.org/lkml/ac76aada-f94d-d596-9b3c-1dca5a9914d0@linux.ibm.com
    #
    local num_cpus=$(nproc --all)

    if [[ $num_cpus -lt 16 ]]; then
	num_cpu_cols=2
    elif [[ $num_cpus -lt 64 ]]; then
	num_cpu_cols=4
    elif [[ $num_cpus -lt 128 ]]; then
	num_cpu_cols=8
    else
	num_cpu_cols=16
    fi
    echo ${num_cpu_cols}
}

# Return the height we want for our htop pane.
# This is a function of the # of cores in the system, as well as the htop config.
function htop-pane-height()
{
    local num_header_rows=4 # Assuming 3 rows of system info (plus blank).
    local num_cpus=$(nproc --all) # See htop-num-cpu-cols for explanation of --all.
    local num_cpu_cols=$(htop-num-cpu-cols)
    # FIXME: This will break if cols doesn't divide num_cpus evenly
    local num_cpu_rows=$(($num_cpus/$num_cpu_cols))
    local num_trailing_rows=2
    echo $(($num_header_rows+$num_cpu_rows+$num_trailing_rows))
}

function tmux-new-session()
{
    SESSION=$1
    # x & y set the width & height of the session, which otherwise is uninferred
    # until the session is first attached. This is necessary for resizing panes
    # below to work correctly.
    tmux new-session -ds $SESSION -x $COLUMNS -y $LINES
}

function tmux-config-modular()
{
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
}

function tmux-config-cpu()
{
    # Start htop pane
    tmux split-window -v
    tmux send-keys 'htop' C-m
    tmux resize-pane -y $(htop-pane-height)
    tmux last-pane
}

function get-num-gpus()
{
    if [[ -x "$(command -v amd-smi)" ]]; then
	# amd-smi includes a header row, so subtract 1
	# NB: current version seems to also include a blank line at the end, but only
	# in interactive shells. so we can ignore that here.
	NUM_GPUS=$(($(amd-smi --list --csv | wc -l)-1))
    else
	NUM_GPUS=$(nvidia-smi --list-gpus | wc -l)
    fi
    echo ${NUM_GPUS}
}

function tmux-config-gpu()
{
    tmux split-window -v
    tmux send-keys 'nvtop' C-m
    # We would prefer to resize this pane directly with -y 3, but this unfortunately
    # adds the new space to the pane below rather than the pane above. There may be
    # a method for specifying the "primary" pane or something like that, but I'm not
    # aware of it. Instead, we switch back to the primary pane and resize it bigger,
    # which shrinks the GPU pane down to desired size.
    tmux last-pane
    DIVIDERS=2
    NUM_GPUS=$(get-num-gpus)
    # NB: We assume here that the screen is wide enough that nvtop will render two
    # GPUs per line, but not so wide that it does 4. We should probably add some
    # smarts here.
    NUM_GPU_PAIRS=$((($NUM_GPUS+1)/2))
    GPU_PANE_SIZE=$((3*$NUM_GPU_PAIRS))
    CPU_PANE_SIZE=$(htop-pane-height)
    PRIMARY_PANE_SIZE=$(($LINES-$CPU_PANE_SIZE-$GPU_PANE_SIZE-$DIVIDERS))
    tmux resize-pane -y $PRIMARY_PANE_SIZE
}

# Attach to session "default" if it exists.
# Otherwise, create it and attach.
function tmux-default()
{
    DEFAULT_SESSION="default"
    tmux has-session -t $DEFAULT_SESSION &> /dev/null

    if [[ $? != 0 ]] ; then
	tmux-new-session $DEFAULT_SESSION
	tmux-config-modular
	tmux-config-cpu
    fi

    # Attach!
    tmux attach -t $DEFAULT_SESSION
}

function tmux-nv()
{
    SESSION="nv"
    tmux has-session -t $SESSION &> /dev/null

    if [[ $? != 0 ]] ; then
	tmux-new-session $SESSION
	tmux-config-cpu
	tmux-config-gpu
    fi

    # Attach!
    tmux attach -t $SESSION
}

alias tmn='tmux-nv'
alias tmd='tmux-default'
alias tmk='tmux kill-server'
