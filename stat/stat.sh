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
## Text manipulation
##

alias trim-whitespace='xargs echo'

##
## DNS
##

## FIXME: Conditional aliases like this don't seem to work in bash.
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    alias dns-domain='scutil --dns | grep domain | head -1 | cut -d: -f2 | trim-whitespace'
    alias dns-ip='scutil --dns | grep nameserver | head -1 | cut -d: -f2 | trim-whitespace'
else # Assuming linux
    alias dns-domain='resolvectl status | grep -i domain | cut -d: -f2 | trim-whitespace'
    alias dns-ip='resolvectl status | grep "Current DNS Server" | cut -d: -f2 | trim-whitespace'
fi

function system-stat()
{
    echo "Architecture: $(uname -m)"
    echo "Operating System: $(uname -o)"
    echo "DNS: $(dns-domain) [$(dns-ip)]"
}
