# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="a command-line utility for converting 24/32-bit PNG images to paletted (8-bit) PNGs"
HOMEPAGE="http://pngquant.org/"
SRC_URI="http://pngquant.org/${P}-src.tar.bz2"

LICENSE="HPND rwpng"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug lcms openmp cpu_flags_x86_sse2"

RDEPEND="media-libs/libpng:0=
	sys-libs/zlib:=
	lcms? ( media-libs/lcms:2 )"
DEPEND="${RDEPEND}"

src_configure() {
	tc-export AR CC
	# Hand rolled configure script, so not all flags are supported.
	./configure \
		--prefix="${EPREFIX}/usr" \
		$(use debug && echo --enable-debug) \
		$(use_enable cpu_flags_x86_sse2 sse) \
		$(use openmp && tc-has-openmp && echo --with-openmp) \
		$(use_with lcms lcms2) \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc CHANGELOG README.md
}
