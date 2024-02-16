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
HTOP_RC_PATH  := $(HOME)/.config/htop/htoprc
NUM_HTOP_COLS := $(shell bash -c "source $(TKD)/term/tmux.sh && htop-num-cpu-cols")

##
## Install dependencies
##

install-deps:
ifeq ($(OS), Darwin)
	brew install coreutils     # Install GNU utils like `ls` as `gls`
	brew install util-linux    # Install GNU column & more
	brew install sponge
endif

##
## Install dotfiles
##

install-core:
	ln -rfs $(TKD)/core/tk.inputrc $(HOME)/.inputrc

install-editor:
	ln -rfs $(TKD)/editor/tk.emacs        $(HOME)/.emacs
	ln -rfs $(TKD)/editor/tk.emacs.d      $(HOME)/.emacs.d
	ln -rfs $(TKD)/editor/tk.editorconfig $(HOME)/.editorconfig

install-stat:
	mkdir -p $(dir $(HTOP_RC_PATH))
	ln -rfs $(TKD)/stat/htop-cpu$(NUM_HTOP_COLS).cfg $(HTOP_RC_PATH)

install-term:
	ln -rfs $(TKD)/term/tk.tmux.conf $(HOME)/.tmux.conf

install-toolchain:
	ln -rfs $(TKD)/toolchain/tk.gdbinit $(HOME)/.gdbinit

install-vcs:
	ln -rfs $(TKD)/vcs/tk.gitignore $(HOME)/.gitignore
	ln -rfs $(TKD)/vcs/tk.gitconfig $(HOME)/.gitconfig
	ln -rfs $(TKD)/vcs/modular.gitconfig $(HOME)/.modular.gitconfig # Note dot

install: install-core install-editor install-stat
install: install-toolchain install-term install-vcs

install:
	echo "source $(TKD)/tk.bashrc" >> $(HOME)/.bashrc
	echo "source $(TKD)/tk.zshrc"  >> $(HOME)/.zshrc
