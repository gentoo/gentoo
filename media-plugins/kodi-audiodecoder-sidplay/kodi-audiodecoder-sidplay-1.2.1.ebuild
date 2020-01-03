# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="SidPlay decoder addon for Kodi"
HOMEPAGE="https://github.com/notspiff/audiodecoder.sidplay"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/notspiff/audiodecoder.sidplay.git"
	inherit git-r3
	;;
*)
	CODENAME="Leia"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/notspiff/audiodecoder.sidplay/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/audiodecoder.sidplay-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-18*
	media-libs/libsidplay:2"

RDEPEND="
	${DEPEND}
	"

src_prepare(){
	[ -d depends ] && rm -rf depends || die
	cmake_src_prepare
}
