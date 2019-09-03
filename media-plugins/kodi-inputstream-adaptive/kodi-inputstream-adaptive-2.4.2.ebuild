# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="Kodi's Adaptive inputstream addon"
HOMEPAGE="https://github.com/peak3d/inputstream.adaptive.git"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/peak3d/inputstream.adaptive.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	CODENAME="Leia"
	SRC_URI="https://github.com/peak3d/inputstream.adaptive/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/inputstream.adaptive-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/expat
	=media-tv/kodi-18*
	=media-libs/kodi-platform-18*
	=dev-libs/libplatform-2*
	"
RDEPEND="
	${DEPEND}
	"
