# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

COMMIT="2a90c2f9a1f3e5889336a8df5426ff99b0318b0f"

inherit cmake-utils kodi-addon

DESCRIPTION="Kodi PVR addon VNSI"
HOMEPAGE="https://github.com/kodi-pvr/pvr.vdr.vnsi"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/kodi-pvr/pvr.vdr.vnsi.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-pvr/pvr.vdr.vnsi/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.vdr.vnsi-${COMMIT}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-17*
	=media-libs/kodi-platform-17*
	virtual/opengl
	"

RDEPEND="
	${DEPEND}
	"
