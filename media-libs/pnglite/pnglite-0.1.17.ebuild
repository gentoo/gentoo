# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="Small and simple library for loading and writing PNG images"
HOMEPAGE="http://sourceforge.net/projects/pnglite/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/${P}-include-stdio.patch
	sed -ie "s:\"../zlib/zlib.h\":<zlib.h>:" pnglite.c || die
}

src_compile() {
	tc-export CC
	if use static-libs; then
		emake ${PN}.o
		$(tc-getAR) -cvq lib${PN}.a ${PN}.o || die
		rm ${PN}.o || die
	fi

	append-flags -fPIC
	emake ${PN}.o
	$(tc-getCC) ${LDFLAGS} -shared -Wl,-soname,lib${PN}.so.0 \
		-o lib${PN}.so.0 ${PN}.o -lz || die
}

src_install() {
	insinto /usr/include
	doins ${PN}.h

	dolib.so lib${PN}.so.0
	if use static-libs; then
		dolib.a lib${PN}.a
	fi

	dosym lib${PN}.so.0 /usr/$(get_libdir)/lib${PN}.so
}
