# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="Kodi's Filmon client addon"
HOMEPAGE="https://github.com/kodi-pvr/pvr.filmon"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/kodi-pvr/pvr.filmon.git"
	inherit git-r3
	;;
*)
	CODENAME="Krypton"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-pvr/pvr.filmon/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.filmon-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-9999
	=media-libs/kodi-platform-9999
	dev-libs/jsoncpp
	"

RDEPEND="
	${DEPEND}
	"
