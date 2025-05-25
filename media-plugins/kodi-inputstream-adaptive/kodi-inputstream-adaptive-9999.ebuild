# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Kodi's Adaptive inputstream addon"
HOMEPAGE="https://github.com/xbmc/inputstream.adaptive.git"

case ${PV} in
9999)
	EGIT_REPO_URI="https://github.com/xbmc/inputstream.adaptive.git"
	EGIT_BRANCH="Matrix"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	SRC_URI="https://github.com/xbmc/inputstream.adaptive/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/inputstream.adaptive-${PV}-${CODENAME}"
	KEYWORDS="~amd64 ~x86"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/expat
	=media-tv/kodi-${PV%%.*}*
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_prepare() {
	if [[ -d depends ]]; then
		rm -r depends || die
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/kodi"
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
