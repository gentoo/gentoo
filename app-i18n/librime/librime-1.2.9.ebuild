# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils vcs-snapshot

DESCRIPTION="Rime Input Method Engine library"
HOMEPAGE="http://rime.im/ https://github.com/rime/librime"
SRC_URI="https://github.com/rime/${PN}/archive/rime-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/1"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="static-libs test"

RDEPEND="app-i18n/opencc:=
	dev-cpp/glog:=
	>=dev-cpp/yaml-cpp-0.5.0:=
	>=dev-libs/boost-1.46.0:=[threads]
	dev-libs/leveldb:=
	dev-libs/marisa:="
DEPEND="${RDEPEND}
	x11-proto/xproto
	test? ( dev-cpp/gtest )"

src_configure() {
	local mycmakeargs=(
		-DBOOST_USE_CXX11=ON
		-DBUILD_DATA=OFF
		-DBUILD_SEPARATE_LIBS=OFF
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DBUILD_STATIC=$(usex static-libs)
		-DBUILD_TEST=$(usex test)
	)

	cmake-utils_src_configure
}
