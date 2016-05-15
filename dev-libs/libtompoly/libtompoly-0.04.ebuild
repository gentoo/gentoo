# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit toolchain-funcs multilib

DESCRIPTION="portable ISO C library for polynomial basis arithmetic"
HOMEPAGE="http://www.libtom.org/"
SRC_URI="https://github.com/libtom/libtompoly/releases/download/${PV}/ltp-${PV}.tar.bz2"

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
