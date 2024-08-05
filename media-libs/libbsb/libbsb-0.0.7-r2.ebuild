# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Portable C library for reading and writing BSB format image files"
HOMEPAGE="https://libbsb.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="media-libs/libpng
	media-libs/tiff:="
RDEPEND="${DEPEND}"

# "make check" in 0.0.7 fails with newer tiff versions (4.0.0) altough the
# tools work perfectly, so restrict test until this is fixed upstream
RESTRICT="test"

src_prepare(){
	sed -i -e "s|ar crv|$(tc-getAR) crv|" Makefile.am || die
	default
	eautoreconf
}
