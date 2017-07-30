# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="Kodi's DVBViewer client addon"
HOMEPAGE="https://github.com/kodi-pvr/pvr.dvbviewer"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/kodi-pvr/pvr.dvbviewer.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/pvr.dvbviewer-${PV}"
	SRC_URI="https://github.com/kodi-pvr/pvr.dvbviewer/archive/${PV}.tar.gz -> ${P}.tar.gz"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-17*
	=media-libs/kodi-platform-17*
	dev-libs/tinyxml
	"

RDEPEND="
	${DEPEND}
	"
