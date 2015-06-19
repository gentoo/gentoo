# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtompoly/libtompoly-0.04.ebuild,v 1.9 2012/06/03 02:29:02 vapier Exp $

EAPI="4"

inherit toolchain-funcs multilib

DESCRIPTION="portable ISO C library for polynomial basis arithmetic"
HOMEPAGE="http://poly.libtomcrypt.org/"
SRC_URI="http://poly.libtomcrypt.org/files/ltp-${PV}.tar.bz2"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-libs/libtommath"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e 's:\<ar\>:$(AR):' \
		-e "/^LIBPATH/s:/lib:/$(get_libdir):" \
		makefile || die
	tc-export AR CC
}

src_install() {
	default
	dodoc changes.txt *.pdf
	docinto demo ; dodoc demo/*
}
