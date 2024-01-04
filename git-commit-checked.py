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
##            Copyright © 2024 Tyler J. Kenney. All rights reserved.              ##
####################################################################################
####################################################################################

from argparse import ArgumentParser
from argparse import RawTextHelpFormatter as RTHF

import os
import subprocess

DESCRIPTION = '''
Utility to catch common git commit errors.

This utility is a wrapper around the traditional `git commit` command. It parses the
given options as well as the current state of the repository to check for common
mistakes. So long as no issues are found, all options are forwarded to the underlying
`git commit` command.
'''

def main():
    ## Parse Args
    parser = ArgumentParser(description=DESCRIPTION,
                            formatter_class=lambda prog: RTHF(prog, max_help_position=80))
    parser.add_argument(
        '--all','-a',action='store_true',
        help='Automatically stage files that have been modified or deleted.\n'
        'This will fail if any files have been manually staged.'
    )
    args, unknown = parser.parse_known_args()

    ## If --all was passed, check if anything is staged. If the stage is non-empty,
    ## it usually means I'm passing -a by mistake, so error out.
    if args.all:
        stage = subprocess.run("git diff --staged --quiet".split(), check=False)
        stage_empty = (stage.returncode == 0)

        if not stage_empty:
            raise RuntimeError(
                'git commit --all with pre-staged files? Are you sure?\n'
                'Note: Use explicit "git commit" to override this check.'
            )

    ## ALL CHECKS PASSED: Forward command
    command = ['git', 'commit']
    if args.all:
        command.append(' --all')
    command += unknown
    subprocess.run(command, check=False, capture_output=False)
    return


if __name__ == '__main__': main()
