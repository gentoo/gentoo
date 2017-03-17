# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="Libretro compatibility layer for the Kodi Game API"
HOMEPAGE="https://github.com/xbmc/peripheral.joystick"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/xbmc/peripheral.joystick.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/xbmc/peripheral.joystick/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/peripheral.joystick-${PV}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	>media-tv/kodi-17.0.9999:0
	=media-tv/kodi-17*:0
	=media-libs/kodi-platform-17*
	=dev-libs/libplatform-2*
	dev-libs/libpcre
	"
RDEPEND="
	${DEPEND}
	"
