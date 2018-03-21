# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit cmake-utils eutils

DESCRIPTION="Mechanized Assault and Exploration Reloaded"
HOMEPAGE="http://www.maxr.org/"
SRC_URI="http://www.maxr.org/downloads/${P}.tar.gz"

LICENSE="GPL-2 FDL-1.2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE="dedicated"

RDEPEND=">=sys-devel/gcc-4.6:*
	media-libs/libsdl2[video]
	media-libs/sdl2-mixer[vorbis]
	media-libs/sdl2-net"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.8"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use dedicated MAXR_BUILD_DEDICATED_SERVER)
		"-DCMAKE_BUILD_TYPE=Release")

	cmake-utils_src_configure
}

src_compile () {
	cmake-utils_src_compile
}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/*
	doicon data/maxr.png
	make_desktop_entry maxr "Mechanized Assault and Exploration Reloaded"
	cmake-utils_src_install
}
