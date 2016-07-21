# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Clock randomness gathering daemon"
HOMEPAGE="http://echelon.pl/pubs/"
SRC_URI="http://echelon.pl/pubs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="sys-devel/gcc"
RDEPEND=""

src_compile() {
	econf --bindir=/usr/sbin || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
	newinitd ${FILESDIR}/clrngd-init.d clrngd
	newconfd ${FILESDIR}/clrngd-conf.d clrngd
}
