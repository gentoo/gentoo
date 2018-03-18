# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils desktop

DESCRIPTION="Mechanized Assault and Exploration Reloaded"
HOMEPAGE="http://www.maxr.org/"
SRC_URI="http://www.maxr.org/downloads/${P}.tar.gz"

LICENSE="GPL-2 FDL-1.2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated"

RDEPEND="media-libs/libsdl2[video]
	media-libs/sdl2-mixer[vorbis]
	media-libs/sdl2-net"
DEPEND="${RDEPEND}"

src_configure() {
	mycmakeargs=(
		-DMAXR_BUILD_DEDICATED_SERVER="$(usex dedicated)"
		"-DCMAKE_BUILD_TYPE=Release")

	cmake-utils_src_configure
}

src_install() {
	doicon data/maxr.png
	make_desktop_entry maxr "Mechanized Assault and Exploration Reloaded"
	cmake-utils_src_install
}
