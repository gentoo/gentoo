# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="Kodi's VuPlus client addon"
HOMEPAGE="https://github.com/kodi-pvr/pvr.vuplus"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/kodi-pvr/pvr.vuplus.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-pvr/pvr.vuplus/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.vuplus-${PV}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	media-tv/kodi
	media-libs/kodi-platform
	dev-libs/tinyxml
	"

RDEPEND="
	${DEPEND}
	"
