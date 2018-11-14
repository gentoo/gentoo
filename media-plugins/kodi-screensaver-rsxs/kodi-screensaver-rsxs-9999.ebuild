# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kodi-addon

DESCRIPTION="RSXS screensaver for Kodi"
HOMEPAGE="https://github.com/notspiff/screensavers.rsxs"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/notspiff/screensavers.rsxs.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/notspiff/screensavers.rsxs/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/screensavers.rsxs-${PV}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	media-tv/kodi
	media-libs/libpng:=
	sys-libs/zlib
	media-libs/glu
	virtual/opengl
	"

RDEPEND="
	media-libs/libpng:=
	sys-libs/zlib
	virtual/opengl
	media-libs/glu
	"
