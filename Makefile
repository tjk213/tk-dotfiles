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

##
## Globals
##

OS := $(shell uname -s)
THIS_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
HTOP_RC_PATH  := $(HOME)/.config/htop/htoprc
NUM_HTOP_COLS := $(shell bash -c "source $(THIS_DIR)/term/tmux.sh && htop-num-cpu-cols")

##
## Default target
##

all: # For now, all does nothing.

##
## Install dependencies
##

install-deps:
ifeq ($(OS), Darwin)
	brew install coreutils     # Install GNU utils like `ls` as `gls`
	brew install util-linux    # Install GNU column & more
	brew install sponge
else ifeq ($(OS), Linux)
	apt-get install moreutils  # Install sponge
endif

##
## Install dotfiles
##
##  TODO: Put these files into a list and loop through them rather than explicitly
##   coding all of this.
##

install-core:
	ln -rfs $(THIS_DIR)/core/tk.inputrc $(HOME)/.inputrc
uninstall-core:
	rm -f $(HOME)/.inputrc

install-editor:
	ln -rfs $(THIS_DIR)/editor/tk.emacs        $(HOME)/.emacs
	ln -rfs $(THIS_DIR)/editor/tk.emacs.d      $(HOME)/.emacs.d
	ln -rfs $(THIS_DIR)/editor/tk.editorconfig $(HOME)/.editorconfig
uninstall-editor:
	rm -f $(HOME)/.emacs
	rm -f $(HOME)/.emacs.d
	rm -f $(HOME)/.editorconfig

install-stat:
	mkdir -p $(dir $(HTOP_RC_PATH))
	ln -rfs $(THIS_DIR)/stat/htop-cpu$(NUM_HTOP_COLS).cfg $(HTOP_RC_PATH)
uninstall-stat:
	rm -f $(HTOP_RC_PATH)

install-term:
	ln -rfs $(THIS_DIR)/term/tk.tmux.conf $(HOME)/.tmux.conf
uninstall-term:
	rm -f $(HOME)/.tmux.conf

install-toolchain:
	ln -rfs $(THIS_DIR)/toolchain/tk.gdbinit $(HOME)/.gdbinit
uninstall-toolchain:
	rm -f $(HOME)/.gdbinit

install-vcs:
	ln -rfs $(THIS_DIR)/vcs/tk.gitignore $(HOME)/.gitignore
	ln -rfs $(THIS_DIR)/vcs/tk.gitconfig $(HOME)/.gitconfig
	ln -rfs $(THIS_DIR)/vcs/modular.gitconfig $(HOME)/.modular.gitconfig # Note dot
uninstall-vcs:
	rm -f $(HOME)/.gitignore
	rm -f $(HOME)/.gitconfig
	rm -f $(HOME)/.modular.gitconfig # Note dot

## For top-level startup files, we install by editing home directory rather than
## symlinking it. This leaves a place for one-off configuration in the home dir.
install-top: uninstall-top
	echo "source $(THIS_DIR)/tk.bashrc" >> $(HOME)/.bashrc
	echo "source $(THIS_DIR)/tk.zshrc"  >> $(HOME)/.zshrc
uninstall-top:
	grep -v 'source .*/tk.bashrc' $(HOME)/.bashrc | sponge $(HOME)/.bashrc
	grep -v 'source .*/tk.zshrc'  $(HOME)/.zshrc  | sponge $(HOME)/.zshrc

install-dotfiles: install-core install-editor install-stat
install-dotfiles: install-toolchain install-term install-vcs install-top

uninstall-dotfiles: uninstall-core uninstall-editor uninstall-stat
uninstall-dotfiles: uninstall-toolchain uninstall-term uninstall-vcs uninstall-top

dirs:
	mkdir -p $(HOME)/apps $(HOME)/backups $(HOME)/venvs $(HOME)/workspace
