# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Image editor with tiff, jpeg and png support"
HOMEPAGE="http://sf-xpaint.sourceforge.net/"
SRC_URI="mirror://sourceforge/sf-xpaint/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="pgf tiff"
# jpeg2k disabled for blocking media-libs/openjpeg:0 security cleanup, bug 735592

RDEPEND="
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/libpng:0=
	x11-libs/libICE
	x11-libs/libX11
	>=x11-libs/libXaw3dXft-1.6.2c[unicode]
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	sys-libs/zlib
	media-libs/libjpeg-turbo:=
	pgf? ( media-libs/libpgf )
	tiff? (
		media-libs/jbigkit:0=
		media-libs/tiff:0
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

src_prepare() {
	default
	sed -i -e 's/-O3 -s//g' util/Makefile || die
}

src_configure() {
	econf \
		$(use_enable tiff) \
		--disable-libopenjpeg
}

src_compile() {
	# clean up
	emake clean
	emake -C util clean

	# parallel make still fails sometimes
	emake substads
	emake xpaint.1

	default
	emake \
		WITH_PGF="$(usex pgf "yes" "no")" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		-C util
}

src_install() {
	default
	emake \
		WITH_PGF="$(usex pgf "yes" "no")" \
		DESTDIR="${ED}" \
		-C util install
	doicon icons/xpaint.svg
	make_desktop_entry "${PN}"
	find "${D}" -name '*.la' -type f -delete || die
	find "${D}" -name '*.a' -type f -delete || die
}
