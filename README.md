# tk-dotfiles
``` Java
====================================================================================
==               ,:                                                         ,:    ==
==             ,' |                                                       ,' |    ==
==            /   :                                                      /   :    ==
==         --'   /       :::::::::::   :::::::::::   :::    :::       --'   /     ==
==         \/ />/           :+:            :+:       :+:   :+:        \/ />/      ==
==         / /_\           +:+            +:+       +:+  +:+          / /_\       ==
==      __/   /           +-+            +-+       ++++:++         __/   /        ==
==      )'-. /           +-+            +-+       +-+  +-+         )'-. /         ==
==      ./  :\          /+/        /+/ /+/       +++   +++         ./  :\         ==
==       /.' '         /=/         /====/       +++    +++          /.' '         ==
==     */.                                                        */.             ==
==     +                                                          +               ==
==    +                                                          +                ==
====================================================================================
============ "Copyright © 2022 Tyler J. Kenney. All rights reserved." ==============
====================================================================================
```

## Installation

To first order, `tk-dotfiles` can be installed simply by symlinking all dotfiles in this repo from your home directory. Non-dotfiles do not require any setup. Any exceptions & additional steps are outlined below.

### .bashrc & .zshrc

If you'd like, you can directly link the startup files like all other dotfiles but it's probably better to source from your home dir:
```
% echo "source $(realpath .)/.bashrc" >> $HOME/.bashrc
% echo "source $(realpath .)/.zshrc"  >> $HOME/.zshrc
```
This leaves any default system configuration that's been placed in your startup files in place (save for anything that's explicitly overwritten, of course).

### HTOP

`htop` reads its config from `$HOME/.config/htop/htoprc`. So this is the file that must be linked to the desired config:

  - `htop-cpu2.cfg`: 2 columns of CPU meters
  - `htop-cpu4.cfg`: 4 columns of CPU meters
  - `htop-cpu8.cfg`: 8 columns of CPU meters

### CCACHE

In `coreutils.sh`, we set `CCACHE_CONFIGPATH` to point into this repo. This means the local copy of `ccache.conf` will be used automatically; no setup necessary. However, the default _data_ directory for ccache is `$HOME/.ccache/`, which is typically mounted on the system's root filesystem partition. On systems where root partitions have limited capacity, overriding this setting or linking `$HOME/.ccache/` may be advisable.

## Notes on Repo Access

It is sometimes wise to access github with a non-default RSA key. If this is desired, the easiest way to clone the repo is:

```
% GIT_SSH_COMMAND='ssh -i /path/to/private/key' git clone git@github.com:tjk213/tk-dotfiles.git
```

Once you've got the repo, you can avoid `GIT_SSH_COMMAND` in the future by pointing git to any given keyfile with:

```
% git config --local core.sshcommand 'ssh -i /path/to/my/key'
```

We don't want to assume that all repos on the client machine are using the same key and/or talking to the same github account, so we use `--local` to limit this configuration to repo scope. (Otherwise, you could run this config prior to the clone and avoid `GIT_SSH_COMMAND` entirely). You can confirm the results with `git config --list --show-scope`.

That's it - your local copy of `tk-dotfiles` (or, perhaps, your user account or whole machine) now has access to your github profile, and from there it can access any repo to which your github account has read/write privileges.
