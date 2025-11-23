# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Super Audio CD ISO-Image decoder addon for Kodi"
HOMEPAGE="https://github.com/xbmc/audiodecoder.sacd"

case ${PV} in
9999)
	EGIT_REPO_URI="https://github.com/xbmc/audiodecoder.sacd.git"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	SRC_URI="https://github.com/xbmc/audiodecoder.sacd/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/audiodecoder.sacd-${PV}-${CODENAME}"
	KEYWORDS="~amd64 ~x86"
	;;
esac

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND="
	media-sound/wavpack
	=media-tv/kodi-${PV%%.*}*
	virtual/libiconv
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/kodi"
	)
	cmake_src_configure
}
