# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils games

MY_PN=Atlas
MY_PV=${PV/_p/.cvs}
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Chart Program to use with Flightgear Flight Simulator"
HOMEPAGE="http://atlas.sourceforge.net/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

COMMON_DEPEND="
	media-libs/freeglut
	media-libs/glew
	>=media-libs/libpng-1.5
	net-misc/curl
	sys-libs/zlib
	virtual/glu
	virtual/jpeg
	virtual/opengl
"
DEPEND="${COMMON_DEPEND}
	>=dev-games/simgear-3.0.0
	media-libs/plib
"
RDEPEND="${COMMON_DEPEND}
	>=games-simulation/flightgear-3.0.0
"

S=${WORKDIR}/${MY_PN}

src_prepare() {
	eautoreconf
}

src_configure() {
	egamesconf \
		--datadir="${GAMES_DATADIR}"/flightgear \
		--disable-dependency-tracking \
		--enable-simgear-shared \
		--with-fgbase="${GAMES_DATADIR}"/flightgear
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "You now can make the maps with the following commands:"
	elog "${GAMES_BINDIR}/Map --atlas=${GAMES_DATADIR}/flightgear/Atlas"
	elog
	elog "To run Atlas concurrently with FlightGear use the following:"
	elog "Atlas --path=[path of map images] --udp=[port number]"
	elog "and start fgfs with the following switch (or in .fgfsrc):"
	elog "--nmea=socket,out,0.5,[host that you run Atlas on],[port number],udp"
	echo
}

pkg_postrm() {
	elog "You must manually remove the maps if you don't want them around."
	elog "They are found in the following directory:"
	echo
	elog "${GAMES_DATADIR}/flightgear/Atlas"
	echo
}
