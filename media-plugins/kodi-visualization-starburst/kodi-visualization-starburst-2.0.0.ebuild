# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="StarBurst visualizer for Kodi"
HOMEPAGE="https://github.com/notspiff/visualization.starburst"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/notspiff/visualization.starburst.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	CODENAME="Leia"
	SRC_URI="https://github.com/notspiff/visualization.starburst/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/visualization.starburst-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-18*
	media-libs/glm
	virtual/opengl
	"

RDEPEND="
	${DEPEND}
	"
