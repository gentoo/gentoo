# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PN=atlas-hgcode
MY_PV=d4e5360f8273823205d9dc066547f5077ffc13e2
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Chart Program to use with Flightgear Flight Simulator"
HOMEPAGE="http://atlas.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~reavertm/${MY_P}.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

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
BDEPEND="app-arch/unzip"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default
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
