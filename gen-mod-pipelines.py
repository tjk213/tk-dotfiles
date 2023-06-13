#!/usr/bin/env python3
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

import os
import re
import sys
import subprocess

from typing import List

PIPELINES = [
    { 'name': 'tf_to_mo', 'start': 'tf-to-mo{prune-assert-ops=true use-mo-ops=true}' },
    { 'name': 'shape_inference', 'start': 'resolve-unknown-parameters' },
    { 'name': 'mo_to_mogg', 'start': 'mo.graph(deparameterize-mo-ops)' },
    { 'name': 'mo_fusion',  'start': 'mo.graph(fuse-elementwise{dump-dot-graph=false})' },
    { 'name': 'mogg_to_mgp','start': 'jit-compile-kernels{create-mogg-reproducers=false dump-stub=false min-cpu-alignment=16 save-temp-prefix= use-search=false}' }
]

def print_header():
    THIS_FILE = os.path.basename(__file__)
    print("####################################################################################")
    print("##               ,:                                                         ,:    ##")
    print("##             ,' |                                                       ,' |    ##")
    print("##            /   :                                                      /   :    ##")
    print("##         --'   /       :::::::::::   :::::::::::   :::    :::       --'   /     ##")
    print("##         \/ />/           :+:            :+:       :+:   :+:        \/ />/      ##")
    print("##         / /_\           +:+            +:+       +:+  +:+          / /_\       ##")
    print("##      __/   /           +#+            +#+       +#++:++         __/   /        ##")
    print("##      )'-. /           +#+            +#+       +#+  +#+         )'-. /         ##")
    print("##      ./  :\          #+#        #+# #+#       #+#   #+#         ./  :\         ##")
    print("##       /.' '         ###         #####        ###    ###          /.' '         ##")
    print("##     '/'                                                        '/'             ##")
    print("##     +                                                          +               ##")
    print("##    '                                                          '                ##")
    print("####################################################################################")
    print("##            Copyright © 2023 Tyler J. Kenney. All rights reserved.              ##")
    print("####################################################################################")
    print("####################################################################################")

    print(f"")
    print(f"## NOTICE: DO NOT EDIT!!")
    print(f"## NOTICE: This file was autogenerated by {THIS_FILE}")
    print(f"## NOTICE: DO NOT EDIT!!")
    return

def get_pipeline_passes(pipeline: str) -> List[str]:
    cmd = f'echo "" | tf-opt --dump-pass-pipeline --{pipeline}'
    output = subprocess.run(cmd, shell=True, capture_output=True)
    lines = output.stderr.decode('utf-8').split('\n')

    pass_manager = re.match(r'Pass Manager with (\d+) passes:',lines[0])
    passes_dump  = re.match(r'builtin.module\((.*)\)',lines[1])

    assert pass_manager, "Failed to parse title"
    assert passes_dump, "Failed to parse passes"

    num_passes = pass_manager.group(1)
    passes = passes_dump.group(1).split(',')

    print(f'{pipeline}: {num_passes} passes',file=sys.stderr)
    return passes

def main():

    ##
    ## Get the global list of passes that we want to break up
    ##

    passes = []
    passes += (get_pipeline_passes('tf-to-mo'))
    passes += (get_pipeline_passes('mo-to-mgp'))

    ##
    ## Verify that every start pass occurs exactly once
    ##

    for p in PIPELINES:
        assert passes.count(p['start']) > 0, f'{p["name"]}: Missing start pass?'
        assert passes.count(p['start']) < 2, f'{p["name"]}: Repeated start pass?'

    ##
    ## Extract pass list for each sub-pipeline
    ##

    idx = 0
    for i in range(len(PIPELINES)-1):
        end_idx = passes.index(PIPELINES[i+1]['start'])
        PIPELINES[i]['passes'] = passes[idx:end_idx]
        idx = end_idx

    PIPELINES[-1]['passes'] = passes[idx::]

    ##
    ## Print results
    ##

    print_header()
    for p in PIPELINES:
        print(f'\n')
        print(f'## Sub-Pipeline: {p["name"]}')
        print(f'export {p["name"]}="builtin.module(')
        print(f',\n'.join(p['passes']))
        print(f')"')

    return

if __name__ == '__main__': main()