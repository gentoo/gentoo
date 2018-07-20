# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="Kodi's Njoy N7 client addon"
HOMEPAGE="https://github.com/kodi-pvr/pvr.njoy"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/kodi-pvr/pvr.njoy.git"
	inherit git-r3
	;;
*)
	CODENAME="Krypton"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-pvr/pvr.njoy/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.njoy-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-9999
	=media-libs/kodi-platform-9999
	dev-libs/tinyxml
	"

RDEPEND="
	${DEPEND}
	"
