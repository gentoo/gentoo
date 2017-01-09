# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="Kodi's Adaptive inputstream addon"
HOMEPAGE="https://github.com/peak3d/inputstream.adaptive.git"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/peak3d/inputstream.adaptive.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/peak3d/inputstream.adaptive/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/inputstream.adaptive-${PV}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	media-tv/kodi
	media-libs/kodi-platform
	=dev-libs/libplatform-2*
	"
RDEPEND="
	${DEPEND}
	"
