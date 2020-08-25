# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="Shadertoy visualizer for Kodi"
HOMEPAGE="https://github.com/xbmc/visualization.shadertoy"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/xbmc/visualization.shadertoy.git"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/xbmc/visualization.shadertoy/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/visualization.shadertoy-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	~media-tv/kodi-9999
	>=media-libs/glm-0.9.9.8-r1
	virtual/opengl
	"

RDEPEND="
	${DEPEND}
	"

src_prepare() {
	if [ -d depends ]; then rm -rf depends || die; fi
	cmake_src_prepare
}
