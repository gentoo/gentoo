# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="Spectrum visualizer for Kodi"
HOMEPAGE="https://github.com/xbmc/visualization.spectrum"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/xbmc/visualization.spectrum.git"
	inherit git-r3
	;;
*)
	CODENAME="Leia"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/xbmc/visualization.spectrum/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/visualization.spectrum-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	~media-tv/kodi-9999
	media-libs/glm
	virtual/opengl
	"

RDEPEND="
	${DEPEND}
	"

src_prepare(){
	[ -d depends ] && rm -rf depends || die
	cmake_src_prepare
}
