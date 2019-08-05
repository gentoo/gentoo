# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="bNES GameClient for Kodi"
HOMEPAGE="https://github.com/kodi-game/game.libretro.bnes"
SRC_URI=""

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/kodi-game/game.libretro.bnes.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	CODENAME="Leia"
	SRC_URI="https://github.com/kodi-game/game.libretro.bnes/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/game.libretro.bnes-${PV}-${CODENAME}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-18*
	games-emulation/libretro-bnes
	"
RDEPEND="
	media-plugins/kodi-game-libretro
	${DEPEND}
	"
src_prepare() {
	echo 'find_library(BNES_LIB NAMES bnes_libretro${CMAKE_SHARED_LIBRARY_SUFFIX} PATH_SUFFIXES libretro)' > "${S}/Findlibretro-bnes.cmake" || die
	default
}
