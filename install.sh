#!/bin/zsh

set -e
THIS_DIR="${0:A:h}"

function init-system-debian()
{
    DEBIAN_PACKAGES=(build-essential xclip)
    DEBIAN_PACKAGES+=(clang llvm lld lldb ccache cmake)
    DEBIAN_PACKAGES+=(tmux git git-lfs emacs)
    DEBIAN_PACKAGES+=(moreutils) # Install sponge
    DEBIAN_PACKAGES+=(htop nvtop)

    sudo apt-get update
    sudo apt-get install -y ${DEBIAN_PACKAGES}

    # Set emacs-style nav for all GTK applications
    gsettings set org.gnome.desktop.interface gtk-key-theme "Emacs"
}

function init-system-macos()
{
    ## Unautomated packages. These need to be installed manually, may need
    ## settings adjusted, and needed to be added to "Login Items" in system
    ## preferences to run on boot.
    ##
    ##  - MonitorControl: https://github.com/MonitorControl/MonitorControl
    ##  - ScrollReverser: https://github.com/pilotmoon/Scroll-Reverser
    ##
    ## TODO: Add MonitorControl to HOMEBREW_PACKAGES since its available via brew.

    HOMEBREW_PACKAGES=(coreutils)    # Install GNU utils like `ls` as `gls`
    HOMEBREW_PACKAGES+=(util-linux)  # Install GNU column & more
    HOMEBREW_PACKAGES+=(sponge emacs tmux htop)
    HOMEBREW_PACKAGES+=(bitwarden)

    brew install ${HOMEBREW_PACKAGES}

    ## Register caffeine-manager to start on boot via cronjob.
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
    ##    directives may be ignored. For now, user-cron seems to work on my macbook
    ##    so we're going with that.
    ##
    ## References:
    ##    - https://unix.stackexchange.com/questions/109804/crontabs-reboot-only-works-for-root
    ##    - https://apple.stackexchange.com/questions/12819/why-is-cron-being-deprecated

    CRON="/usr/bin/crontab"
    CM="$(realpath ${THIS_DIR}/macos/caffeine-manager.sh)"
    ( ${CRON} -l | grep -v ${CM}; echo "@reboot ${CM}" )| ${CRON} -
}

function init-system()
{
    echo "Initializing system..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
	init-system-macos
    else
	init-system-debian
    fi
}

function init-python()
{
    echo "Initializing python virtual environment..."
    SKIP_VENV_ACTIVATION=1 source ${THIS_DIR}/core/coreutils.sh
    python${DEFAULT_PYTHON_VERSION} -mvenv $DEFAULT_VENV
}

function mk-user-dirs() {
    echo "Initializing user directories..."
    mkdir -p ${HOME}/apps ${HOME}/backups ${HOME}/venvs ${HOME}/workspace
}

function uninstall-top() {
    grep -v 'source .*/tk.bashrc' ${HOME}/.bashrc | sponge ${HOME}/.bashrc
    grep -v 'source .*/tk.zshrc'  ${HOME}/.zshrc  | sponge ${HOME}/.zshrc
}

function install-top()
{
    # Uninstall first, to make sure we don't create duplicate entries.
    uninstall-top

    # For top-level startup files, we install by editing home directory rather than
    # symlinking it. This leaves a place for one-off configuration in the home dir.
    echo "source ${THIS_DIR}/tk.bashrc" >> ${HOME}/.bashrc
    echo "source ${THIS_DIR}/tk.zshrc"  >> ${HOME}/.zshrc
}

function install-dotfiles()
{
    echo "Initializing user configuration..."

    HTOP_RC_PATH="${HOME}/.config/htop/htoprc"
    NUM_HTOP_COLS=$(source ${THIS_DIR}/term/tmux.sh && htop-num-cpu-cols)
    HTOP_CONFIG=htop-cpu${NUM_HTOP_COLS}.cfg

    # Setup subdirs
    mkdir -p $(dirname ${HTOP_RC_PATH})

    # Link secondary dotfiles
    if [[ "$OSTYPE" == "darwin"* ]]; then
	alias ln='gln'
    fi

    ln -rfs ${THIS_DIR}/core/tk.inputrc        ${HOME}/.inputrc           # Core
    ln -rfs ${THIS_DIR}/editor/tk.emacs        ${HOME}/.emacs             # Editor
    ln -rfs ${THIS_DIR}/editor/tk.emacs.d      ${HOME}/.emacs.d
    ln -rfs ${THIS_DIR}/editor/tk.editorconfig ${HOME}/.editorconfig
    ln -rfs ${THIS_DIR}/stat/${HTOP_CONFIG}    ${HTOP_RC_PATH}            # Stat
    ln -rfs ${THIS_DIR}/term/tk.tmux.conf      ${HOME}/.tmux.conf         # Term
    ln -rfs ${THIS_DIR}/toolchain/tk.gdbinit   ${HOME}/.gdbinit           # Toolchain
    ln -rfs ${THIS_DIR}/vcs/tk.gitignore       ${HOME}/.gitignore         # VCS
    ln -rfs ${THIS_DIR}/vcs/tk.gitconfig       ${HOME}/.gitconfig
    ln -rfs ${THIS_DIR}/vcs/modular.gitconfig  ${HOME}/.modular.gitconfig # Note dot

    # Source top-level dotfiles
    install-top
}

function uninstall-dotfiles()
{
    rm -f ${HOME}/.inputrc
    rm -f ${HOME}/.emacs
    rm -f ${HOME}/.emacs.d
    rm -f ${HOME}/.editorconfig
    rm -f ${HOME}/.tmux.conf
    rm -f ${HOME}/.gdbinit
    rm -f ${HOME}/.gitignore
    rm -f ${HOME}/.gitconfig
    rm -f ${HOME}/.modular.gitconfig # Note dot
}

function print-success()
{
    echo "Install complete."
    echo ""
    echo "System Status"
    echo "============="
    source ${THIS_DIR}/stat/stat.sh && system-stat
}

##
## Main
##

init-system
mk-user-dirs
install-dotfiles
init-python
print-success
