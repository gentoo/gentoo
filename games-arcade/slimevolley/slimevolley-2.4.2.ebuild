# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils eutils games

DESCRIPTION="A simple volleyball game"
HOMEPAGE="http://slime.tuxfamily.org/index.php"
SRC_URI="http://downloads.tuxfamily.org/slime/v242/${PN}_${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="net"

RDEPEND="media-libs/libsdl[X,sound,video]
	media-libs/sdl-ttf
	media-libs/sdl-image[png]
	net? ( media-libs/sdl-net )
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext"

DOCS="docs/README docs/TODO"

PATCHES=( "${FILESDIR}"/${P}-nodatalocal.patch
	"${FILESDIR}"/${P}-underlink.patch )

S=${WORKDIR}/${PN}

src_configure() {
	mycmakeargs=(
	"-DCMAKE_VERBOSE_MAKEFILE=TRUE"
	"-DBIN_DIR=${GAMES_BINDIR}"
	$(use net && echo "-DNO_NET=0" || echo "-DNO_NET=1")
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
