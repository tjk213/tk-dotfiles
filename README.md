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

## Repository Access

The most popular protocol for github access is `SSH`. This requires a pair of ssh keys which can be generated with:

```
% ssh-keygen -trsa -C "my_email@isp.com" # Leave passphrase empty
```

Next, upload the public key to your github account in `settings -> SSH & GPG Keys -> New SSH Key`.

If you saved the generated private key in the default file (`$HOME/.ssh/id_rsa`), then you're all set. Otherwise, you can clone the repo with:

```
% GIT_SSH_COMMAND='ssh -i /path/to/private/key' git clone git@github.com:tjk213/tk-dotfiles.git
```

Once you've got the repo, you can avoid `GIT_SSH_COMMAND` in the future by pointing git to any given keyfile with:

```
% git config --local core.sshcommand 'ssh -i /path/to/my/key'
```

We don't want to assume that all repos on the client machine are using the same key and/or talking to the same github account, so we use `--local` to limit this configuration to repo scope. (Otherwise, you could run this config prior to the clone and avoid `GIT_SSH_COMMAND` entirely). You can confirm the results with `git config --list --show-scope`.

That's it - your local copy of `tk-dotfiles` (or, perhaps, your user account or whole machine) now has access to your github profile, and from there it can access any repo to which your github account has read/write privileges.

## Installation

Most files in this repo can be activated by symlinking them from your home directory - the exceptions are noted below.

**TODO**: Should we write a setup script for creating these links? This could include OS-based conditionals like the one below for `htop`.

> _**NB**: For z-shell, we could point `ZDOTDIR` to this repo as an alternative installation method. Is there something similar for bash? See section 2.2 of the [zshell user's guide](https://zsh.sourceforge.io/Guide/zshguide02.html). But where do we set `ZDOTDIR`? This might create a chicken-and-the-egg problem._ 🤔

### .bashrc

If you'd like, you can directly link `$HOME/.bashrc` to `tk-dotfiles/.bashrc`, but it's probably better to source from your home dir to `tk-dotfiles`:
```
% echo "source $(realpath .)/.bashrc" >> $HOME/.bashrc
```

### HTOP

`htop` reads its config from `$HOME/.config/htop/htoprc`. So this is the file that must be linked to the desired config:

  - `htop-cpu2.cfg`: 2 columns of CPU meters
  - `htop-cpu4.cfg`: 4 columns of CPU meters

### CCACHE

In `coreutils.sh`, we set `CCACHE_CONFIGPATH` to point into this repo. This means the local copy of `ccache.conf` will be used automatically; no setup necessary. However, the default _data_ directory for ccache is `$HOME/.ccache/`, which is typically mounted on the system's root filesystem partition. On systems where root partitions have limited capacity, overriding this setting or linking `$HOME/.ccache/` may be advisable.
