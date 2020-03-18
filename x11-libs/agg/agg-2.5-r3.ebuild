# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="High quality rendering engine library for C++"
HOMEPAGE="http://antigrain.com/"
SRC_URI="http://antigrain.com/${P}.tar.gz"

LICENSE="GPL-2 gpc? ( free-noncomm )"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="+gpc sdl static-libs +truetype +X"

# preffer X with enabled xcb, really
RDEPEND="
	sdl? ( >=media-libs/libsdl-1.2.0[X?] )
	X? ( >=x11-libs/libX11-1.3.99.901 )
	truetype? ( media-libs/freetype:2 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=( readme authors ChangeLog news )

# patches taken from fedora
PATCHES=(
	"${FILESDIR}"/agg-2.4-depends.patch
	"${FILESDIR}"/${P}-pkgconfig.patch
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-sdl-m4.patch
	"${FILESDIR}"/${P}-sdl-automagic.patch
	"${FILESDIR}"/${P}-gcc8.patch
	"${FILESDIR}"/${PVR}
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	AT_M4DIR="." eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-ctrl
		--disable-examples
		$(use_enable gpc)
		$(use_enable sdl)
		$(use_enable static-libs static)
		$(use_enable truetype freetype)
		$(use_with X x)
	)
	econf ${myeconfargs[@]}
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
