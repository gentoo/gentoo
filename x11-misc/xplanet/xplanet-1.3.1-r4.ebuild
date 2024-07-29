# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Render images of the earth into the X root window"
HOMEPAGE="https://xplanet.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gif jpeg png tiff truetype X"

RDEPEND="
	gif? ( media-libs/giflib:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? (
		media-libs/libpng:0=
		media-libs/netpbm
	)
	tiff? ( media-libs/tiff:= )
	truetype? (
		media-libs/freetype:2
		x11-libs/pango
	)
	X? (
		x11-libs/libX11
		x11-libs/libXScrnSaver
		x11-libs/libXext
		x11-libs/libXt
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	truetype? ( virtual/pkgconfig )
	X? ( x11-base/xorg-proto )
"

PATCHES=(
	"${FILESDIR}"/${P}-giflib.patch
	"${FILESDIR}"/${P}-narrowing_conversion.patch
	"${FILESDIR}"/${P}-remove-null-comparison.patch
	"${FILESDIR}"/${P}-freetype_pkgconfig.patch #788136
)

src_prepare() {
	default
	eautoreconf #788136
}

src_configure() {
	# econf says 'checking pnm.h presence... no'
	use png && append-cppflags -I"${EPREFIX}"/usr/include/netpbm

	local myconf=(
		--with-freetype$(usex truetype '' '=no')
		--with-gif$(usex gif '' '=no')
		--with-jpeg$(usex jpeg '' '=no')
		--with-pango$(usex truetype '' '=no')
		--with-png$(usex png '' '=no')
		--with-pnm$(usex png '' '=no')
		--with-tiff$(usex tiff '' '=no')
		--with-x$(usex X '' '=no')
		--with-xscreensaver$(usex X '' '=no')
	)
	econf --with-cspice=no "${myconf[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}
