# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/hsc/hsc-1.0b.ebuild,v 1.5 2010/01/01 16:11:34 ssuominen Exp $

inherit autotools eutils

DESCRIPTION="An HTML preprocessor using ML syntax"
HOMEPAGE="http://www.linguistik.uni-erlangen.de/~msbethke/software.html"
SRC_URI="http://www.linguistik.uni-erlangen.de/~msbethke/binaries/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

S=${WORKDIR}/${PN}-${PV/b/}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-cflags.patch"
	epatch "${FILESDIR}/${P}-nostrip.patch"
	epatch "${FILESDIR}/${P}-parmake.patch"
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch
	eautoreconf
}

src_install() {
	dodir /usr/share/hsc
	emake BINDIR="${D}/usr/bin" DATADIR="${D}/usr/share/hsc" \
		prefix="${D}/usr" docdir="${D}/usr/share/doc/${PF}" \
		datadir="${D}/usr/share/hsc" install || die "make install failed"
}
