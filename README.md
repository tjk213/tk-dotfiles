## test2

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

## Quickstart

``` bash
% # Install packages & initialize other system-wide settings.
% sudo make init-system USERNAME=tyler
% # Install dotfiles, this will symlink everything from the home dir and therefore
% # overwrite the user's existing files.
% make install-dotfiles
% # Make default directories
% make dirs
```
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
