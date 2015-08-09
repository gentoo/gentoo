# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# the hddtemp executable
HDDTEMP_EXEC=/usr/sbin/hddtemp

# various options to pass to the daemon
HDDTEMP_OPTS="--listen=127.0.0.1"

# a list of drives to check
HDDTEMP_DRIVES="/dev/sda /dev/sdb"

