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

If you saved the generated private key in the default file (`$HOME/.ssh/id_rsa`), then you're all set. Otherwise, you can point git to any given keyfile with:

```
% git config --local core.sshcommand 'ssh -i /path/to/my/key'
```

We don't want to assume that all repos on the client machine are using the same key and/or talking to the same github account, so we use `--local` to limit this configuration to repo scope. You can confirm the results with `git config --list --show-scope`.

That's it - your local copy of `tk-dotfiles` (or, perhaps, your user account or whole machine) now has access to your github profile, and from there it can access any repo to which your github account has read/write privileges.
