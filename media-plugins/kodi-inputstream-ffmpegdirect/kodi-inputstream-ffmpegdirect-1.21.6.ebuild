# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kodi-addon

DESCRIPTION="Kodi's FFMpeg Direct Inputstream addon"
HOMEPAGE="https://github.com/xbmc/inputstream.ffmpegdirect"
SRC_URI=""

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/xbmc/inputstream.ffmpegdirect.git"
	EGIT_BRANCH="Matrix"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~arm64 ~x86"
	CODENAME="Matrix"
	SRC_URI="https://github.com/xbmc/inputstream.ffmpegdirect/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/inputstream.ffmpegdirect-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

BDEPEND="
	virtual/pkgconfig
	"

COMMON_DEPEND="
	media-video/ffmpeg[encode,libxml2,zlib]
	virtual/libiconv
	app-arch/bzip2
	=media-tv/kodi-19*
	"

DEPEND="
	${COMMON_DEPEND}
	"

RDEPEND="
	${COMMON_DEPEND}
	"

src_prepare() {
	[ -d depends ] && rm -rf depends || die
	cmake_src_prepare
}
