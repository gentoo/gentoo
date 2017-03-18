# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

MY_PN=atlas-hgcode
MY_PV=e183e3b3a0412b504edcb3664445b3e04fd484a2
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Chart Program to use with Flightgear Flight Simulator"
HOMEPAGE="http://atlas.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~reavertm/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

COMMON_DEPEND="
	media-libs/freeglut
	media-libs/glew:0
	>=media-libs/libpng-1.5:0
	net-misc/curl
	sys-libs/zlib
	virtual/glu
	virtual/jpeg:*
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
)

DOCS=(AUTHORS NEWS README)

src_prepare() {
	default_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		--datadir=/usr/share/flightgear \
		--disable-dependency-tracking \
		--enable-simgear-shared \
		--with-fgbase=/usr/share/flightgear
}

pkg_postinst() {
	elog "To run Atlas concurrently with FlightGear use the following:"
	elog "Atlas --path=[path of map images] --udp=[port number]"
	elog "and start fgfs with the following switch (or in .fgfsrc):"
	elog "--nmea=socket,out,0.5,[host that you run Atlas on],[port number],udp"
	echo
}
