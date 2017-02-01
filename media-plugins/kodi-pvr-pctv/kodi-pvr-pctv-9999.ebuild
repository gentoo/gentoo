# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="Kodi's PCTV client addon"
HOMEPAGE="https://github.com/kodi-pvr/pvr.pctv"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/kodi-pvr/pvr.pctv.git"
	inherit git-r3
	;;
*)
	CODENAME="Krypton"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-pvr/pvr.pctv/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.pctv-${PV}-${CODENAME}"
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
