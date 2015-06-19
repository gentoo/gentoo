# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/phex/files/phex-3.0.0.99.sh,v 1.1 2007/01/12 14:23:05 armin76 Exp $

#!/bin/sh

java -classpath $(java-config -p commons-logging,commons-httpclient-3,phex,jgoodies-looks-2.0,jgoodies-forms) phex.Main
