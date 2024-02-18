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
## Init system
##
## Install system-wide packages, some of which are strict dependencies for subsequent
## targets in this makefile, others may just be commonly used packages. This is
## system-wide, so only necessary to run once even if we have multiple accounts.
##

ifeq ($(OS), Darwin)
init-system: init-system-macos
else ifeq ($(OS), Linux)
## FIXME: For now, we assume linux == debian
init-system: init-system-debian
endif

## Debian init
DEBIAN_PACKAGES += build-essential
DEBIAN_PACKAGES += clang llvm lld lldb ccache
DEBIAN_PACKAGES += tmux git emacs
DEBIAN_PACKAGES += moreutils  # Install sponge

init-system-debian:
	apt-get update
	apt-get install $(DEBIAN_PACKAGES)

## MacOS init
USAGE = "USAGE: sudo make init-system USERNAME=my-username"
HOMEBREW_PACKAGES += coreutils  # Install GNU utils like `ls` as `gls`
HOMEBREW_PACKAGES += util-linux # Install GNU column & more
HOMEBREW_PACKAGES += sponge

## Register caffeinate to start on boot via cronjob.
##
## For some reason I cannot find any combination of settings in system preferences
## that let my screensaver play indefinitely (when on AC power). The only solution
## I am able to find is running caffeinate in a terminal, so we register it to
## start on boot.
##
## We use crontab's @reboot syntax to register the command on boot. According to
## the internet, cron has been deprecated in favor of launchd / launchctl but, in
## my experience launchd is tremendously complicated and cron is easy so we're
## going with that. Despite the deprecation, it seems unlikely that apple will
## actually remove support for cron (this would break posix compliance?) and even
## if this were to occur homebrew or some other community would presumably provide
## an alternative distribution.
##
## Although, imo, launchd is worse there are still some gotcha's with this cron
## solution:
##
##  - There is no builtin way to append a job from the command line; only over-
##    write. This means we have to build our own pipeline for appending.
##
##  - On some systems, @reboot may only work in the root's crontab. You can
##    write an @reboot line as any user of course, but user-level @reboot
##    directives may be ignored. This means that accidentally executing this
##    target without sudo would fail silently, so we include an explicit check for
##    the root user.
##
## References:
##    - https://unix.stackexchange.com/questions/109804/crontabs-reboot-only-works-for-root
##    - https://apple.stackexchange.com/questions/12819/why-is-cron-being-deprecated
CRON = crontab
CAFFEINATE = /usr/bin/caffeinate
CRON_FILTER   = $(CRON) -l | grep -v $(CAFFEINATE)
CRON_REGISTER = echo '@reboot $(CAFFEINATE) -isd'

caffeinate-on-boot:
ifneq ($(USER), root)
	$(warning $(USAGE))
	$(error "caffeinate requires superuser permissions.")
endif
	( $(CRON_FILTER); $(CRON_REGISTER) ) | $(CRON) -

## On macos, `brew install` needs to be run from user account but other init steps
## need sudo, plus we want an identical install flow between mac & linux. Therefore,
## we make the user pass in their username and use sudo to, believe it or not, drop
## privilege level before installing.
macos-install-packages:
ifndef USERNAME
	$(warning $(USAGE))
	$(error "init-system-macos requires username")
endif
	sudo -u $(USERNAME) brew install $(HOMEBREW_PACKAGES)

init-system-macos: macos-install-packages caffeinate-on-boot

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
