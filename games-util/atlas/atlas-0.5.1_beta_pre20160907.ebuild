# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_PN=atlas-hgcode
MY_PV=e183e3b3a0412b504edcb3664445b3e04fd484a2
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Chart Program to use with Flightgear Flight Simulator"
HOMEPAGE="http://atlas.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~reavertm/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	media-libs/freeglut
	media-libs/glew:0=
	media-libs/libpng:0=
	net-misc/curl
	sys-libs/zlib
	virtual/glu
	virtual/jpeg:0
	virtual/opengl
"
DEPEND="${COMMON_DEPEND}
	>=dev-games/simgear-3.0.0
	media-libs/plib
"
RDEPEND="${COMMON_DEPEND}
	>=games-simulation/flightgear-3.0.0
"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${P}-simgear-compilation.patch"
	"${FILESDIR}/${P}-jpeg-9.patch"
)

src_prepare() {
	default

	# -Wnarrowing failure, #612986
	sed -i -e 's:0x:(char)0x:g' src/tiles.h || die

	eautoreconf
}

src_configure() {
	econf \
		--datadir="${EPREFIX}"/usr/share/flightgear \
		--enable-simgear-shared \
		--with-fgbase="${EPREFIX}"/usr/share/flightgear
}

pkg_postinst() {
	elog "To run Atlas concurrently with FlightGear use the following:"
	elog "Atlas --path=[path of map images] --udp=[port number]"
	elog "and start fgfs with the following switch (or in .fgfsrc):"
	elog "--nmea=socket,out,0.5,[host that you run Atlas on],[port number],udp"
}
