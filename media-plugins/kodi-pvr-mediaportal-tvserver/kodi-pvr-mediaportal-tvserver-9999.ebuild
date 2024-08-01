# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kodi-addon

DESCRIPTION="Kodi's MediaPortal TVServer client addon"
HOMEPAGE="https://github.com/kodi-pvr/pvr.mediaportal.tvserver"


case ${PV} in
9999)
	
	EGIT_REPO_URI="https://github.com/kodi-pvr/pvr.mediaportal.tvserver.git"
	inherit git-r3
	DEPEND="~media-tv/kodi-9999"
	;;
*)
	CODENAME="Matrix"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-pvr/pvr.mediaportal.tvserver/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.mediaportal.tvserver-${PV}-${CODENAME}"
	DEPEND="=media-tv/kodi-19*"
	;;
esac

LICENSE="GPL-2"
SLOT="0"


DEPEND+="
	dev-libs/tinyxml
	"

RDEPEND="
	${DEPEND}
	"
