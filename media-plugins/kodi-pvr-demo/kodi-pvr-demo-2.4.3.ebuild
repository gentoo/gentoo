# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="Demo PVR for Kodi"
HOMEPAGE="https://github.com/kodi-pvr/pvr.demo"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/kodi-pvr/pvr.demo.git"
	inherit git-r3
	;;
*)
	CODENAME="Krypton"
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/kodi-pvr/pvr.demo/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.demo-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-16*
	=media-libs/kodi-platform-16*
	dev-libs/tinyxml
	"

RDEPEND="
	${DEPEND}
	"
