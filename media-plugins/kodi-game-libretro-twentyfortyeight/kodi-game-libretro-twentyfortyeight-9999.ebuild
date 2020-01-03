# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="2048 for Kodi"
HOMEPAGE="https://github.com/kodi-game/game.libretro.2048"
SRC_URI=""

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/kodi-game/game.libretro.2048.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	CODENAME="Leia"
	SRC_URI="https://github.com/kodi-game/game.libretro.2048/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/game.libretro.2048-${PV}-${CODENAME}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	~media-tv/kodi-9999
	games-emulation/libretro-twentyfortyeight
	"
RDEPEND="
	media-plugins/kodi-game-libretro
	${DEPEND}
	"

src_prepare() {
	echo 'find_library(2048_LIB NAMES 2048_libretro${CMAKE_SHARED_LIBRARY_SUFFIX} PATH_SUFFIXES libretro)' > "${S}/Findlibretro-2048.cmake" || die
	cmake_src_prepare
}
