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

install-core:
	ln -rfs $(TKD)/core/tk.inputrc $(HOME)/.inputrc

install-editor:
	ln -rfs $(TKD)/editor/tk.emacs        $(HOME)/.emacs
	ln -rfs $(TKD)/editor/tk.emacs.d      $(HOME)/.emacs.d
	ln -rfs $(TKD)/editor/tk.editorconfig $(HOME)/.editorconfig

install-term:
	ln -rfs $(TKD)/term/tk.tmux.conf $(HOME)/.tmux.conf

install-toolchain:
	ln -rfs $(TKD)/toolchain/tk.gdbinit $(HOME)/.gdbinit

install-vcs:
	ln -rfs $(TKD)/vcs/tk.gitignore $(HOME)/.gitignore
	ln -rfs $(TKD)/vcs/tk.gitconfig $(HOME)/.gitconfig
	ln -rfs $(TKD)/vcs/modular.gitconfig $(HOME)/modular.gitconfig

install: install-core install-editor install-toolchain install-term install-vcs
	echo "source $(TKD)/tk.bashrc" >> $(HOME)/.bashrc
	echo "source $(TKD)/tk.zshrc"  >> $(HOME)/.zshrc
