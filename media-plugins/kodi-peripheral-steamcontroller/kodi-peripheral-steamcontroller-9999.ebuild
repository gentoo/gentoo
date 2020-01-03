# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="Steam controller driver for Kodi"
HOMEPAGE="https://github.com/kodi-game/peripheral.steamcontroller"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/kodi-game/peripheral.steamcontroller.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-game/peripheral.steamcontroller/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/peripheral.steamcontroller-${PV}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	~media-tv/kodi-9999
	~media-libs/kodi-platform-9999
	=dev-libs/libplatform-2*
	virtual/libusb:1
	"
RDEPEND="
	${DEPEND}
	"
