# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ushare/files/ushare.conf.d,v 1.1 2009/12/23 22:27:37 darkside Exp $

# User to run ushare daemon (if none, root will be used)
USHARE_USER="ushare"

# UPNP Friendly Name:
USHARE_NAME="uShare"

# The interface to bind to:
USHARE_IFACE="eth0"

# Static ushare port:
USHARE_PORT=""

# Enable/Disable telnet:
USHARE_TELNET="yes"

# Choose different telnet port:
USHARE_TELNET_PORT=""

# Enable/Disable web component:
USHARE_WEB="yes"

# A List of directories to share, each precieded by '-c':
USHARE_DIRS=""

# Enable/Disable XboX 360 compliant profile:
USHARE_XBOX="no"

# Enable/Disable DLNA compliant profile (Playstation3 requires this):
USHARE_DLNA="no"

# Misc. options:
USHARE_OPTS=""

# Check ushare --help or man ushare for more options.
