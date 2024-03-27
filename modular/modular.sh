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
export L=$HOME/workspace/llama-benchmarking
export R=$HOME/workspace/roblox-benchmarking
export F=$HOME/workspace/ferrari-benchmarking

## Early-return if the monorepo doesn't exist; presumably we're not on a modular
## system.
if [[ ! -d "$M" ]]; then
    return 1
fi

##
## Python
##

DISABLE_CHDIR=1 source $M/utils/start-modular.sh
unset -f model
alias install-python-deps='install_python_deps'
alias install-dev-deps='install_dev_deps'

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
## MLIR Hacks
##

## There is one blank line in modular MLIR files between the end of the code and the start of
## the weights. These aliases take advantage of this to extract the various components.
alias mlir-extract-code="sed '/^$/,\$d'"
alias mlir-extract-weights="sed '0, /^$/d'"

##
## MLIR Pipelines
##

if [[ -f  "${TKD}/modular/modular-pipelines.sh" ]] ; then
    source ${TKD}/modular/modular-pipelines.sh
fi

alias onnx-translate='onnx-translate --onnx-version-update --onnx-shape-inference --import-onnx'

function dump-op-graph() {
    faux-opt --dump-op-graph --allow-unregistered-dialect $1 1>/dev/null
}

function tf-to-mgp()
{
    filepath=$1
    filename=$(basename $filepath)
    parts=(${(s/./)filename})
    root=${parts[1]}

    dump-op-graph $filepath 2>$root.tf.dot
    echo "tf-to-mgp: ${root}.tf.mlir"
    tf-opt -p $tf_to_mo $filepath > $root.mo.mlir
    dump-op-graph $root.mo.mlir 2>$root.mo.dot
    echo "tf-to-mgp: ${root}.mo.mlir"
    tf-opt -p $shape_inference $root.mo.mlir > $root.mosi.mlir
    dump-op-graph $root.mosi.mlir 2>$root.mosi.dot
    echo "tf-to-mgp: ${root}.mosi.mlir"
    tf-opt -p $mo_to_mogg $root.mosi.mlir > $root.mogg.mlir
    dump-op-graph $root.mogg.mlir 2>$root.mogg.dot
    echo "tf-to-mgp: ${root}.mogg.mlir"
    tf-opt -p $mo_fusion $root.mogg.mlir > $root.mofu.mlir
    dump-op-graph $root.mofu.mlir 2>$root.mofu.dot
    echo "tf-to-mgp: ${root}.mofu.mlir"
    tf-opt --allow-unregistered-dialect -p $mogg_to_mgp $root.mofu.mlir > $root.mgp.mlir
    dump-op-graph $root.mgp.mlir 2>$root.mgp.dot
    echo "tf-to-mgp: ${root}.mgp.mlir"
}

function onnx-to-mgp()
{
    filepath=$1
    filename=$(basename $filepath)
    parts=(${(s/./)filename})
    root=${parts[1]}

    dump-op-graph $filepath 2>$root.onnx.dot
    echo "onnx-to-mgp: ${root}.monnx.mlir"
    onnx-opt -p $monnx_lowering $filepath > $root.mo.mlir
    dump-op-graph $root.mo.mlir 2>$root.mo.dot
    echo "onnx-to-mgp: ${root}.mo.mlir"
    onnx-opt -p $shape_inference $root.mo.mlir > $root.mosi.mlir
    dump-op-graph $root.mosi.mlir 2>$root.mosi.dot
    echo "onnx-to-mgp: ${root}.mosi.mlir"
    onnx-opt -p $mo_to_mogg $root.mosi.mlir > $root.mogg.mlir
    dump-op-graph $root.mogg.mlir 2>$root.mogg.dot
    echo "onnx-to-mgp: ${root}.mogg.mlir"
    onnx-opt -p $mo_fusion $root.mogg.mlir > $root.mofu.mlir
    dump-op-graph $root.mofu.mlir 2>$root.mofu.dot
    echo "onnx-to-mgp: ${root}.mofu.mlir"
    onnx-opt --allow-unregistered-dialect -p $mogg_to_mgp $root.mofu.mlir > $root.mgp.mlir
    dump-op-graph $root.mgp.mlir 2>$root.mgp.dot
    echo "onnx-to-mgp: ${root}.mgp.mlir"
}


if [[ -f  "${TKD}/modular/modular-local.sh" ]] ; then
    source ${TKD}/modular/modular-local.sh
fi

##
## LOC Reports
##

export CLOC_MOJO='--force-lang=mojo,mojo'
export CLOC_MLIR='--force-lang="LLVM IR,mlir"'
export CLOC_LITCFG='--force-lang=Python,in' # lit.cfg.py.in --> Python
alias cloc-modular="cloc ${CLOC_MOJO} ${CLOC_MLIR} ${CLOC_LITCFG}"
