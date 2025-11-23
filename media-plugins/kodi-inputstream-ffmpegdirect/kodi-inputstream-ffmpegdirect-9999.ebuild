# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Kodi's FFMpeg Direct Inputstream addon"
HOMEPAGE="https://github.com/xbmc/inputstream.ffmpegdirect"

case ${PV} in
9999)
	EGIT_REPO_URI="https://github.com/xbmc/inputstream.ffmpegdirect.git"
	EGIT_BRANCH="Matrix"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	SRC_URI="https://github.com/xbmc/inputstream.ffmpegdirect/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/inputstream.ffmpegdirect-${PV}-${CODENAME}"
	KEYWORDS="~amd64"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	app-arch/bzip2
	=media-tv/kodi-${PV%%.*}*
	media-video/ffmpeg:=[encode(+),xml(-),zlib]
	virtual/libiconv
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	if [[ -d depends ]]; then
		rm -r depends || die
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/kodi"
	)
	cmake_src_configure
}
