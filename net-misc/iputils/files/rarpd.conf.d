# Config file for /etc/init.d/rarpd

# You probably want to select the interface for this to listen on.
# By default it uses loopback which most likely won't help.
RARPD_IFACE="lo"

# See the rarpd(8) manpage for more info.
RARPD_OPTS="-b /tftpboot"
