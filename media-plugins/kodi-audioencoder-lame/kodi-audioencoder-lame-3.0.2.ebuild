# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="Lame MP3 encoder addon for Kodi"
HOMEPAGE="https://github.com/xbmc/audioencoder.lame"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/xbmc/audioencoder.lame.git"
	inherit git-r3
	DEPEND="~media-tv/kodi-9999"
	;;
*)
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	CODENAME="Matrix"
	SRC_URI="https://github.com/xbmc/audioencoder.lame/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/audioencoder.lame-${PV}-${CODENAME}"
	DEPEND="=media-tv/kodi-19*"
	;;
esac

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND+="
	>=media-sound/lame-3.100
	"

RDEPEND="
	${DEPEND}
	"

src_prepare() {
	[ -d depends ] && rm -rf depends || die
	cmake_src_prepare
}
