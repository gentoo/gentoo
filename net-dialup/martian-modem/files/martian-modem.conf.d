# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/martian-modem/files/martian-modem.conf.d,v 1.1 2012/12/15 16:41:36 pacho Exp $
#
### Configuration for martian-modem initscript
#
### DEVICE
# Device that will martian-modem daemon create to act as modem device.
# Default is /dev/ttySM0.
#DEVICE="/dev/ttySM0"
#
#
### USER/GROUP
# User and group that will have access to the modem device.
# Default values are nobody/dialout.
# Note: the daemon itself needs to be run as root!
#USER="nobody"
#GROUP="dialout"
#
#
### MARTIAN_OPTS
# Other options to be passed to the daemon, see description below.
# Defaults to empty.
# --realtime		- raise priority of threads to realtime.
# --smp			- true smp (symmetric multiprocessing) mode.
# --country=<country>	- two-letter code for the country.
#			  Run `/usr/sbin/martian_modem --info countries` for list.
# --no-cdclose		- keep working with client when carrier lost.
# --hide-pty		- save pty from others as soon its open. Client
#			  should notify it's here writing to device. For callback feature.
#MARTIAN_OPTS=""
#
#
### LOGGING
# Should we log to syslog [YES/NO]
# Default to YES. If you do not want this, say NO here to use LOGFILE instead.
#USE_SYSLOG="YES"
# Alternatively, you can log to a separate file. The default location is below.
#LOGFILE="/var/log/martian-modem.log"
#
#
### DEBUG
# How verbose should the log be [1-5]
# Default debug_level=1; debug_level=3 is suitable for normal debugging.
#DEBUG_LEVEL=1
