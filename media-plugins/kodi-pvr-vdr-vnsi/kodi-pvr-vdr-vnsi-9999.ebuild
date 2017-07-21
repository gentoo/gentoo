# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="Kodi PVR addon VNSI"
HOMEPAGE="https://github.com/fernetmenta/pvr.vdr.vnsi"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/fernetmenta/pvr.vdr.vnsi.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/fernetmenta/pvr.vdr.vnsi/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.vdr.vnsi-${PV}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-9999
	=media-libs/kodi-platform-9999
	virtual/opengl
	"

RDEPEND="
	${DEPEND}
	"
