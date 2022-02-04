# powerbox
An alpine chroot for android users (requires root and busybox)

# Why?
Because we can. Seriously, the base android system is so fucking bloated, so let's just create a chroot and forget about that shit. PowerBox is made specifically for android, because why not?

# How to use?
This script sets up a chroot and installs alpishell, a very nice utility.
to run it, just enter the android root shell and run:
```
curl https://raw.githubusercontent.com/egor4ka/powerbox/main/powerbox.sh | sh
``` 
and you should be done!

# How the fuck is the archive only 60mb?
Because the alpine rootfs is small: only 3mb and the rest is just packages, plus the archive is compressed with gzip

# Can I run services in it?
Yep, it's set up for that so you don't have to worry about stuff

# (any other question here)
The alpine wiki should have all you need

# Where can I get the chroot tarball only, instead of a script?
at https://duckykutya.cf/kat/powerbox/powerbox.tar.gz

# Can I run this on my PC?
Not yet: the chroot (and the alpishell that the shell downloads) is only for arm64 currently, so maybe on a Pi, but not yet on a pc unless you're gonna emulate.

# What's the password?
The default passwords are powerbox for root and powerbox for the powerbox user.

# What are the tweaks you made?
installed zsh, doas, mpv, openssh, bat, nnn, bash, wget, curl, alpine-sdk, github-cli, git, alpine-base 

added the inet group to get socket access to use internet

added the powerbox and root user to inet group

did some stuff to make openrc work (just symlinked some file to make it think that /run/openrc/softlevel exists)

did some tweaks of the /etc/profile (changed PS1)

installed gcc and alpine-base

installed powerlevel10k for the powerbox user

configured doas to permit root without a password and to permit the powerbox user with a password
