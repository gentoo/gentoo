# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="True Type Font to Postscript Type 1 Converter"
HOMEPAGE="http://ttf2pt1.sourceforge.net/"
SRC_URI="mirror://sourceforge/ttf2pt1/${P}.tgz"

LICENSE="ttf2pt1"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND=">=media-libs/freetype-2.5.1:2"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch
	epatch "${FILESDIR}"/${P}-LDFLAGS.patch
	epatch "${FILESDIR}"/${PN}-3.4.0-man-pages.diff
	epatch "${FILESDIR}"/${P}-freetype.patch
	epatch "${FILESDIR}"/${P}-freetype-2.5.patch

	sed -i -e "/^CC=/ { s:gcc:$(tc-getCC): }" Makefile
	sed -i -e "/^CFLAGS_SYS=/ { s:-O.*$:${CFLAGS}: }" Makefile
	sed -i -e "/^LIBS_FT=/ { s:-L/usr/lib:-L/usr/$(get_libdir): }" Makefile
	sed -i -e "/^LIBXDIR =/ { s:libexec:$(get_libdir): }" Makefile
}

src_install() {
	emake INSTDIR="${D}"/usr install
	dodir /usr/share/doc/${PF}
	pushd "${D}"/usr/share/ttf2pt1 > /dev/null
	rm -r app other
	mv [A-Z]* ../doc/${PF}
	popd > /dev/null
}
