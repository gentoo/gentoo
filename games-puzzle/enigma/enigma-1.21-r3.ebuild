# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="Puzzle game similar to Oxyd"
HOMEPAGE="http://www.nongnu.org/enigma/"
SRC_URI="mirror://sourceforge/enigma-game/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	media-fonts/dejavu
	media-libs/sdl-ttf
	media-libs/libsdl[video]
	media-libs/sdl-mixer
	media-libs/sdl-image[jpeg,png]
	media-libs/libpng:0=
	sys-libs/zlib
	net-misc/curl
	|| ( >=dev-libs/xerces-c-3[icu] >=dev-libs/xerces-c-3[-icu,-iconv] )
	net-libs/enet:=
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-gcc6.patch
)

src_prepare() {
	default

	eautoreconf
	config_rpath_update .
}

src_configure() {
	econf \
		--with-system-enet \
		$(use_enable nls)
}

src_install() {
	HTML_DOCS=( doc/.  )
	DOCS=( ACKNOWLEDGEMENTS AUTHORS CHANGES README doc/HACKING )
	default
	doman doc/enigma.6

	dosym \
		../../fonts/dejavu/DejaVuSansCondensed.ttf \
		/usr/share/enigma/fonts/DejaVuSansCondensed.ttf
	dosym \
		../../fonts/dejavu/DejaVuSans.ttf \
		/usr/share/enigma/fonts/vera_sans.ttf
}
