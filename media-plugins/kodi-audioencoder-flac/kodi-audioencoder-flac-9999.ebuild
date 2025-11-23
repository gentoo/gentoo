# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Flac encoder addon for Kodi"
HOMEPAGE="https://github.com/xbmc/audioencoder.flac"

case ${PV} in
9999)
	EGIT_REPO_URI="https://github.com/xbmc/audioencoder.flac.git"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	SRC_URI="https://github.com/xbmc/audioencoder.flac/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/audioencoder.flac-${PV}-${CODENAME}"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	;;
esac

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND="
	media-libs/flac:=
	>=media-libs/libogg-1.3.5
	=media-tv/kodi-${PV%%.*}*
"
RDEPEND="${DEPEND}"

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
