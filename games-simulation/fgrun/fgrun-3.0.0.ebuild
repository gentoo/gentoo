# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit games cmake-utils

# Exported from git tag 3.0.0-final
MY_PN=fg-fgrun
MY_PV=e13e42811239008fded7685d8f2311bb571f6a58
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="A graphical frontend for the FlightGear Flight Simulator"
HOMEPAGE="http://sourceforge.net/projects/fgrun"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug nls"

COMMON_DEPEND="
	>=dev-games/openscenegraph-3.0.1
	sys-libs/zlib
	x11-libs/fltk:1[opengl,threads]
"
DEPEND="${COMMON_DEPEND}
	>=dev-games/simgear-${PV}
	>=dev-libs/boost-1.34
	nls? ( sys-devel/gettext )
"
RDEPEND="${COMMON_DEPEND}
	>=games-simulation/flightgear-${PV}
"

S=${WORKDIR}/${MY_PN}
DOCS=(AUTHORS NEWS)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}
		$(cmake-utils_use_enable nls)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	prepgamesdirs
}
