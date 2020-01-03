# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="Flac encoder addon for Kodi"
HOMEPAGE="https://github.com/xbmc/audioencoder.flac"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/xbmc/audioencoder.flac.git"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	CODENAME="Leia"
	SRC_URI="https://github.com/xbmc/audioencoder.flac/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/audioencoder.flac-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-18*
	>=media-libs/libogg-1.3.4
	media-libs/flac
	"
RDEPEND="
	${DEPEND}
	"

src_prepare(){
	[ -d depends ] && rm -rf depends || die
	cmake_src_prepare
}
