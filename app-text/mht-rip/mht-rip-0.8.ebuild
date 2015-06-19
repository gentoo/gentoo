# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/mht-rip/mht-rip-0.8.ebuild,v 1.1 2010/12/17 18:01:21 c1pher Exp $

DESCRIPTION="convert mht/mhtml files to something usable"
HOMEPAGE="http://www.loganowen.com/mht-rip/"
SRC_URI="http://www.loganowen.com/mht-rip/${P}.c"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}"/${A} ${PN}.c || die
}

src_compile() {
	emake ${PN} || die
}

src_install() {
	dobin ${PN} || die
}
