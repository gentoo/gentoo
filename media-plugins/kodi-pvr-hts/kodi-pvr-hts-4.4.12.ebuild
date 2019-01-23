# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="Tvheadend Live TV and Radio PVR client addon for Kodi"
HOMEPAGE="https://github.com/kodi-pvr/pvr.hts"
SRC_URI=""

if [[ ${PV} == 9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/kodi-pvr/pvr.hts.git"
	inherit git-r3
else
	CODENAME="Leia"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-pvr/pvr.hts/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.hts-${PV}-${CODENAME}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=dev-libs/libplatform-2*
	=media-libs/kodi-platform-18*
	=media-tv/kodi-18*
	"

RDEPEND="
	${DEPEND}
	"
