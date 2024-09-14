# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kodi-addon

DESCRIPTION="Tvheadend Live TV and Radio PVR client addon for Kodi"
HOMEPAGE="https://github.com/kodi-pvr/pvr.hts"

if [[ ${PV} == 9999 ]]; then

	EGIT_REPO_URI="https://github.com/kodi-pvr/pvr.hts.git"
	inherit git-r3
else
	CODENAME="Matrix"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-pvr/pvr.hts/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.hts-${PV}-${CODENAME}"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	=media-tv/kodi-19*
	"

RDEPEND="
	${DEPEND}
	"
