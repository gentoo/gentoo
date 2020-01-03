# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

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
	CODENAME="Leia"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-pvr/pvr.dvbviewer/archive/${PV}-${CODENAME}.tar.gz -> ${P}-${CODENAME}.tar.gz"
	S="${WORKDIR}/pvr.dvbviewer-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	~media-tv/kodi-9999
	~media-libs/kodi-platform-9999
	dev-libs/tinyxml
	"

RDEPEND="
	${DEPEND}
	"
