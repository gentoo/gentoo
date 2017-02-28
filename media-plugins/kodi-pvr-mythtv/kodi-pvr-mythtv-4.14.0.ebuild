# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="MythTV PVR for Kodi"
HOMEPAGE="https://github.com/janbar/pvr.mythtv"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/janbar/pvr.mythtv.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/janbar/pvr.mythtv/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.mythtv-${PV}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	sys-libs/zlib
	=media-tv/kodi-17*
	=media-libs/kodi-platform-17*
	"
RDEPEND="
	${DEPEND}
	"
