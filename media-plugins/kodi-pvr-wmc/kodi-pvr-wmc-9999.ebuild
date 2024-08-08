# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kodi-addon

DESCRIPTION="Kodi's Windows Media Center client addon"
HOMEPAGE="https://github.com/kodi-pvr/pvr.wmc"

case ${PV} in
9999)

	EGIT_REPO_URI="https://github.com/kodi-pvr/pvr.wmc.git"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-pvr/pvr.wmc/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.wmc-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	~media-tv/kodi-9999
	=dev-libs/libplatform-2*
	"
RDEPEND="
	${DEPEND}
	"
