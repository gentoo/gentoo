# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="Kodi's ARGUS TV client addon"
HOMEPAGE="https://github.com/kodi-pvr/pvr.argustv"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/kodi-pvr/pvr.argustv.git"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-pvr/pvr.argustv/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.argustv-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-19*
	dev-libs/jsoncpp
	"

RDEPEND="
	${DEPEND}
	"
