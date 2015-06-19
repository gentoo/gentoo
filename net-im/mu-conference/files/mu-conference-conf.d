# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-im/mu-conference/files/mu-conference-conf.d,v 1.4 2004/07/08 17:35:01 humpback Exp $

CONFIG="/etc/jabber/muctrans.xml"

#Need to find a way to fix the "double" expansion 
#PIDFILE= grep pid ${CONFIG} | sed -e 's/<[^>]*>//g' | sed s/' '//g
PIDFILE="/var/log/jabber/muctrans.pid"
