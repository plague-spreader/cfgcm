# cfgcm

**C**on**f**i**g**urable **C**onnection **M**anager

---

Work in progress.

This guide was written ahead of time just to save me the annoyance of writing a
guide later (and also as a TODO list)

---

Provides the user an URL scheme which enables connection to anything with any
kind of strange options. All protocols are supported, provided you have all the
necessary applications.

All the connections definitions resides in the local machine, so any authority
component in the URL will be discarded. Maybe there is an use case for
connections defined on a remote machine? Let me know if you have any ideas.

## How to use

The URL scheme is: `cfgcm:<path>`

By typing `xdg-open cfgcm:<path>` the following program will be executed:
`${XDG_DATA_HOME:-~/.local/share}/cfgcm/<path>/connect`

Also there is a shorthand to avoid to write the whole path (requires `fzf` as a
requirement though): by executing `cfgcm.sh` a fzf prompt will be shown with
all the defined connections. Moreover, if in the cfgcm path a `description`
file is present, it is possible to map a description to each of the connections
for a more convenient way of visualizing everything.

### Example

Let's say you want to connect to a Cisco router with SSH and you also want a
way to have the password safely copied from the KeepassXC password manager.

You can create the file `~/.local/share/cfgcm/cisco/routers/router-1/connect`
with the following content:

    #!/bin/bash
    konsole -e keepassxc-cli clip ~/passwords.kdbx "Cisco Routers/Router1" &
    ssh -v 2 -c aes256-cbc -m hmac-shal-160 -p 2002 router1.mycompany.com

Then you can connect by executing `xdg-open cfgcm:cisco/routers/router-1` from
a terminal window.

Also, by creating a `~/.local/share/cfgcm/cisco/routers/router-1/description`
file with the following content:

    ssh://router1.mycompany.com - Cisco Router in main hall

fzf will show the description rather than `cisco/routers/router-1` which could
be more convenient (or maybe not? in that case do not create a description for
that entry)

If you want to use this connection by clicking on the link in a GUI application
you need to open a terminal and then open the SSH client

## How to install

If you want to do an user-local installation type:

    make localinstall

if you want to do a system-wide installation type:

    sudo make install
