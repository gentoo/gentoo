# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="a lightweight PDF viewer and toolkit written in portable C"
HOMEPAGE="http://mupdf.com/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="X vanilla"

RDEPEND="media-libs/freetype:2
	media-libs/jbig2dec
	>=media-libs/openjpeg-1.5:0
	virtual/jpeg
	X? ( x11-libs/libX11
		x11-libs/libXext )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		 "${FILESDIR}"/${P}-buildsystem.patch \
		"${FILESDIR}"/${P}-desktop-integration.patch

	if ! use vanilla ; then
		epatch "${FILESDIR}"/${PN}-1.1_rc1-zoom-2.patch
	fi
}

src_compile() {
	use X || my_nox11="NOX11=yes MUPDF= "

	emake CC="$(tc-getCC)" AR="$(tc-getAR)" OS=Linux \
		build=debug verbose=true ${my_nox11}
}

src_install() {
	emake prefix="${ED}usr" libdir="${ED}usr/$(get_libdir)" \
		build=debug verbose=true ${my_nox11} install

	insinto /usr/include
	doins pdf/mupdf{,-internal}.h
	doins fitz/fitz{,-internal}.h
	doins xps/muxps{,-internal}.h

	insinto /usr/$(get_libdir)/pkgconfig
	doins debian/mupdf.pc

	if use X ; then
		domenu debian/mupdf.desktop
		doicon debian/mupdf.xpm
	fi
	dodoc README doc/{example.c,overview.txt}
}
