# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
