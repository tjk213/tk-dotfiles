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
import shutil

from argparse import ArgumentParser
from argparse import RawTextHelpFormatter as RTHF

from unittest import TestCase

DESCRIPTION = "Syntactic sugar for copying or moving files to backup dir."

def main():
    parser = ArgumentParser(
        description=DESCRIPTION,
        formatter_class=lambda prog: RTHF(prog, max_help_position=80)
    )

    parser.add_argument("files",nargs="+",help="File(s) to backup")
    parser.add_argument("--move","-m",action="store_true",help="Move rather than copy")
    parser.add_argument(
        "--backup-dir",
        metavar="/path/to/backup/dir",
        default="~/backups",
        help="Backup directory [Default: ~/backups]"
    )

    args = parser.parse_args()
    backup(**vars(args))

    return

def backup(files, backup_dir, move=False):
    backup_dir = os.path.expanduser(backup_dir)

    for filename in files:
        if os.path.isdir(filename):
            target = backup_dir + "/" + os.path.basename(filename)
            shutil.copytree(filename, target, dirs_exist_ok=True)
        else:
            shutil.copy2(filename, backup_dir)

        if move:
            if os.path.isdir(filename):
                shutil.rmtree(filename)
            else:
                os.remove(filename)

    return

class BackupTestCase(TestCase):
    def __init__(self, methodName):
        super(BackupTestCase, self).__init__(methodName)
        self.methodName = methodName.replace("_","-")
        self.backup_dir = f"{self.methodName}-backup/"

    @classmethod
    def setUpClass(cls):
        super(BackupTestCase, cls).setUpClass()
        os.mkdir("backup-test")
        os.mkdir("backup-test/dir")
        os.mkdir("backup-test/move/")
        os.mkdir("backup-test/move/dir")
        os.mkdir("backup-test/move/dir2")
        open("backup-test/foo", "w").close()
        open("backup-test/bar", "w").close()
        open("backup-test/dir/foo", "w").close()
        open("backup-test/dir/bar", "w").close()
        open("backup-test/move/foo", "w").close()
        open("backup-test/move/bar", "w").close()
        open("backup-test/move/baz", "w").close()
        open("backup-test/move/qux", "w").close()
        open("backup-test/move/dir/foo", "w").close()
        open("backup-test/move/dir/bar", "w").close()
        open("backup-test/move/dir2/foo", "w").close()
        open("backup-test/move/dir2/bar", "w").close()

    @classmethod
    def tearDownClass(cls):
        super(BackupTestCase, cls).tearDownClass()
        shutil.rmtree("backup-test")

    def setUp(self):
        os.mkdir(self.backup_dir)

    def tearDown(self):
        shutil.rmtree(self.backup_dir)

    def check_files(self, files):
        for f in files:
            if not os.path.exists(f"{self.backup_dir}/{f}"):
                return False
        return True

    def run_test(self, files, move):
        files = [f"backup-test/{x}" for x in files]
        backup(files, backup_dir=self.backup_dir, move=move)

    def test_simple_copy(self):
        files = ["foo"]
        self.run_test(files, move=False)
        assert self.check_files(files)

    def test_copy_two(self):
        files = ["foo", "bar"]
        self.run_test(files, move=False)
        assert self.check_files(files)

    def test_double_copy(self):
        files = ["foo"]
        self.run_test(files, move=False)
        self.run_test(files, move=False)
        assert self.check_files(files)

    def test_copy_dir(self):
        files = ["dir"]
        self.run_test(files, move=False)
        assert self.check_files(["dir/foo", "dir/bar"])

    def test_double_copy_dir(self):
        files = ["dir"]
        self.run_test(files, move=False)
        open("backup-test/dir/baz", "w").close()
        self.run_test(files, move=False)
        assert self.check_files(["dir/foo", "dir/bar", "dir/baz"])

    def test_simple_move(self):
        files = ["move/foo"]
        self.run_test(files, move=True)
        assert self.check_files([os.path.basename(x) for x in files])

    def test_move_two(self):
        files = ["move/bar", "move/baz"]
        self.run_test(files, move=True)
        assert self.check_files([os.path.basename(x) for x in files])

    def test_copy_then_move(self):
        files = ["move/qux"]
        self.run_test(files, move=False)
        self.run_test(files, move=True)
        assert self.check_files([os.path.basename(x) for x in files])

    def test_move_dir(self):
        files = ["move/dir"]
        self.run_test(files, move=True)
        assert self.check_files(["dir/foo", "dir/bar"])

    def test_copy_then_move_dir(self):
        files = ["move/dir2"]
        self.run_test(files, move=False)
        open("backup-test/move/dir2/baz", "w").close()
        self.run_test(files, move=True)
        assert self.check_files(["dir2/foo", "dir2/bar", "dir2/baz"])

if __name__ == "__main__": main()
