# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic

DESCRIPTION="Render images of the earth into the X root window"
HOMEPAGE="http://xplanet.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ppc64 ~sparc x86"
IUSE="gif jpeg png tiff truetype X"

RDEPEND="
	gif? ( media-libs/giflib:= )
	jpeg? ( virtual/jpeg:0 )
	png? (
		media-libs/libpng:0=
		media-libs/netpbm
	)
	tiff? ( media-libs/tiff:0 )
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
DEPEND="
	${RDEPEND}
	truetype? ( virtual/pkgconfig )
	X? (
		x11-proto/scrnsaverproto
		x11-proto/xproto
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-giflib.patch
	"${FILESDIR}"/${P}-remove-null-comparison.patch
)

src_configure() {
	# econf says 'checking pnm.h presence... no'
	use png && append-cppflags -I"${EPREFIX}"/usr/include/netpbm

	local myconf=()

	use X \
		&& myconf+=( --with-x --with-xscreensaver ) \
		|| myconf+=( --with-x=no --with-xscreensaver=no )

	use gif \
		&& myconf+=( --with-gif ) \
		|| myconf+=( --with-gif=no )

	use jpeg \
		&& myconf+=( --with-jpeg ) \
		|| myconf+=( --with-jpeg=no )

	use tiff \
		&& myconf+=( --with-tiff ) \
		|| myconf+=( --with-tiff=no )

	use png \
		&& myconf+=( --with-png --with-pnm ) \
		|| myconf+=( --with-png=no --with-pnm=no )

	use truetype \
		&& myconf+=( --with-freetype --with-pango ) \
		|| myconf+=( --with-freetype=no --with-pango=no )

	econf \
		--with-cspice=no \
		"${myconf[@]}"
}
