# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="bNES GameClient for Kodi"
HOMEPAGE="https://github.com/kodi-game/game.libretro.bnes"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/kodi-game/game.libretro.bnes.git"
	inherit git-r3
else
	CODENAME="Matrix"
	SRC_URI="https://github.com/kodi-game/game.libretro.bnes/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/game.libretro.bnes-${PV}-${CODENAME}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	games-emulation/libretro-bnes
	=media-tv/kodi-${PV%%.*}*
"
RDEPEND="${DEPEND}
	media-plugins/kodi-game-libretro
"

src_prepare() {
	echo 'find_library(BNES_LIB NAMES bnes_libretro${CMAKE_SHARED_LIBRARY_SUFFIX} PATH_SUFFIXES libretro)' > \
		"/Findlibretro-bnes.cmake" || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/kodi"
	)
	cmake_src_configure
}
