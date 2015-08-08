# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# required!
TGT_IP=''

DEVICE=eth0

SRC_IP='' 
# will default to first address on $DEVICE
# must be specified if the device does not have an IP at init time
SRC_PORT=6665 # default

# note that cancd daemon uses 6667 as default
# but netconsole.txt says 6666 is the default
TGT_PORT=6667 

# if you want to broadcast, specify 'broadcast' here.
# it's a security hole on an untrusted network.
TGT_MAC='' 

LOGLEVEL='1'
# LOGLEVEL are the kernel console logging levels
# [0..7] = EMERG,ALERT,CRIT,ERR,WARNING,NOTICE,INFO,DEBUG 
# 1 means only kernel panics are reported (default)
# this affects all console logging
# see syslog(2) for more info
