# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="NastyFFT visualizer for Kodi"
HOMEPAGE="https://github.com/notspiff/visualization.nastyfft"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/notspiff/visualization.nastyfft.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/notspiff/visualization.nastyfft/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/visualization.nastyfft-${PV}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	~media-tv/kodi-9999
	virtual/opengl
	"

RDEPEND="
	${DEPEND}
	"
