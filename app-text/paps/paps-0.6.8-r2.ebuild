# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Unicode-aware text to PostScript converter"
HOMEPAGE="http://paps.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x11-libs/pango"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-fix-as-needed-build.patch
	"${FILESDIR}"/${P}-fix-doxygen-acinclude.patch
	"${FILESDIR}"/${P}-fix-freetype-include.patch
	"${FILESDIR}"/${P}-fix-empty-file.patch
)

src_prepare() {
	default

	mv configure.in configure.ac || die

	eautoreconf
}

src_install() {
	dobin src/paps
	doman src/paps.1
	dodoc AUTHORS ChangeLog NEWS README TODO
}
