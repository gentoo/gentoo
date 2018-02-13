# Copyright 1999-2018 Gentoo Foundation
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
	GIT_COMMIT="9af21218a87572bd4ab8d8d660c11f6295144f97"
	SRC_URI="https://codeload.github.com/peak3d/inputstream.adaptive/tar.gz-${GIT_COMMIT} -> ${P}.tar.gz"
	S="${WORKDIR}/inputstream.adaptive-${GIT_COMMIT}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/expat
	=media-tv/kodi-17*
	=media-libs/kodi-platform-17*
	=dev-libs/libplatform-2*
	"
RDEPEND="
	${DEPEND}
	"
