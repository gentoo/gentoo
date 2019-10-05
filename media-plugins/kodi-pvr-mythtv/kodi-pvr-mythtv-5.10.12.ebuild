# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils kodi-addon

DESCRIPTION="MythTV PVR for Kodi"
HOMEPAGE="https://github.com/janbar/pvr.mythtv"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/janbar/pvr.mythtv.git"
	inherit git-r3
	;;
*)
	CODENAME="Leia"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/janbar/pvr.mythtv/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.mythtv-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	sys-libs/zlib
	=media-tv/kodi-18*
	=media-libs/kodi-platform-18*
	"
RDEPEND="
	${DEPEND}
	"
