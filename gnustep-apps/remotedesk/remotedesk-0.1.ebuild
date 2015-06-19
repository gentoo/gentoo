# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/remotedesk/remotedesk-0.1.ebuild,v 1.4 2008/03/08 13:43:18 coldwind Exp $

inherit gnustep-2

MY_P=RemoteDesk-${PV}
DESCRIPTION="GNUstep remote windows access tool"
HOMEPAGE="http://www.nongnu.org/gap/remotedesk/index.html"
SRC_URI="http://savannah.nongnu.org/download/gap/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="net-misc/rdesktop"

S=${WORKDIR}/${MY_P}
