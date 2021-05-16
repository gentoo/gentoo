# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="command-line utility and library for lossy compression of PNG images"
HOMEPAGE="https://pngquant.org/"
SRC_URI="https://pngquant.org/${P}-src.tar.gz"

LICENSE="GPL-3 HPND rwpng"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug lcms openmp cpu_flags_x86_sse2"

RDEPEND="media-libs/libpng:0=
	media-gfx/libimagequant:=
	sys-libs/zlib:=
	lcms? ( media-libs/lcms:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-2.12.2-respect-CFLAGS.patch )

src_prepare() {
	default

	# avoid silent fallback to bundled lib
	rm -rv lib || die
}

src_configure() {
	tc-export AR CC
	# Hand rolled configure script, so not all flags are supported.
	./configure \
		--prefix="${EPREFIX}/usr" \
		--with-libimagequant \
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
