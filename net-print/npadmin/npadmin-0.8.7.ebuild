# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils
DESCRIPTION="Network printer command-line adminstration tool"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://npadmin.sourceforge.net/"
# this does NOT link against SNMP
DEPEND=""
KEYWORDS="x86 ~amd64 ~ppc"
IUSE=""
LICENSE="GPL-2"
SLOT="0"

src_unpack() {
	unpack ${A}
	EPATCH_OPTS="-p1 -d ${S}" epatch ${FILESDIR}/${P}-stdlib.patch
}

src_compile() {
	econf || die
	emake || die "Make failed."
}

src_install() {
	dobin npadmin
	doman npadmin.1
	dodoc README AUTHORS ChangeLog INSTALL NEWS README TODO
}
