The init script for openconnect supports multiple vpn tunnels.

You need to create a symbolic link to /etc/init.d/openconnect in /etc/init.d
instead of calling it directly:

ln -s /etc/init.d/openconnect /etc/init.d/openconnect.vpn0

You can then start the vpn tunnel like this:

/etc/init.d/openconnect.vpn0 start

If you would like to run preup, postup, predown, and/or postdown scripts,
You need to create a directory in /etc/openconnect with the name of the vpn:

mkdir /etc/openconnect/vpn0

Then add executable shell files:

mkdir /etc/openconnect/vpn0
cd /etc/openconnect/vpn0
echo '#!/bin/sh' > preup.sh
cp preup.sh predown.sh
cp preup.sh postup.sh
cp preup.sh postdown.sh
chmod 755 /etc/openconnect/vpn0/*
