# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="Fische visualizer for Kodi"
HOMEPAGE="https://github.com/xbmc/visualization.fishbmc"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/xbmc/visualization.fishbmc.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	CODENAME="Matrix"
	SRC_URI="https://github.com/xbmc/visualization.fishbmc/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/visualization.fishbmc-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-19*
	virtual/opengl
	media-libs/glm
	"

RDEPEND="
	${DEPEND}
	"

src_prepare() {
	[ -d depends ] && rm -rf depends || die
	cmake_src_prepare
}
