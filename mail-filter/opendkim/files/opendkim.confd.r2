# This overrides the "Socket" line in your opendkim.conf configuration
# file, and is required (so that we don't have to try to parse the
# configuration file in an init script). The setting below listens
# on the network.
#OPENDKIM_SOCKET="inet:8891@localhost"
#
# A local (UNIX) socket in combination with an additional group that
# is shared by OpenDKIM and your MTA is safer. Please see
# https://wiki.gentoo.org/wiki/OpenDKIM for more information.
#
# WARNING: The directory containing this socket will have its owner
#          changed to "opendkim".
#
OPENDKIM_SOCKET="local:/run/opendkim/socket"
#
# More examples of valid socket syntax can be found in the opendkim(8)
# man page, under the "-p socketspec" option. However -- contrary to
# what that man page says -- if you want to use a local socket, the
# "local:" prefix is not optional here.
