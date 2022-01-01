# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="Command-line utility and library for lossy compression of PNG images"
HOMEPAGE="https://pngquant.org/ https://github.com/kornelski/pngquant"
SRC_URI="https://github.com/kornelski/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 HPND rwpng"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="cpu_flags_x86_sse2 debug lcms openmp test"

RDEPEND="
	media-libs/libpng:0=
	media-gfx/libimagequant:=
	sys-libs/zlib:=
	lcms? ( media-libs/lcms:2 )
"
DEPEND="${RDEPEND}
	test? ( media-libs/lcms:2 )
	virtual/pkgconfig
"

RESTRICT="!test? ( test )"

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
