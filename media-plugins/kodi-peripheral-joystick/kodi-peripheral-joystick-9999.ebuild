# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kodi-addon

DESCRIPTION="Libretro compatibility layer for the Kodi Game API"
HOMEPAGE="https://github.com/xbmc/peripheral.joystick"


case ${PV} in
9999)
	
	EGIT_BRANCH="Matrix"
	EGIT_REPO_URI="https://github.com/xbmc/peripheral.joystick.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	CODENAME="Matrix"
	SRC_URI="https://github.com/xbmc/peripheral.joystick/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/peripheral.joystick-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"


DEPEND="
	~media-tv/kodi-9999
	dev-libs/libpcre
	dev-libs/tinyxml
	"
RDEPEND="
	${DEPEND}
	"
