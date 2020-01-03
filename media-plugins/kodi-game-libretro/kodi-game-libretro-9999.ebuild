# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="Libretro compatibility layer for the Kodi Game API"
HOMEPAGE="https://github.com/kodi-game/game.libretro"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/kodi-game/game.libretro.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	CODENAME="Leia"
	SRC_URI="https://github.com/kodi-game/game.libretro/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/game.libretro-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	~media-tv/kodi-9999
	~media-libs/kodi-platform-9999
	=dev-libs/libplatform-2*
	"
RDEPEND="
	${DEPEND}
	"
