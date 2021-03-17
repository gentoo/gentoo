# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 688f948c5f3067e775bfab5057e8047f467a9ca9 $

EAPI=7

inherit cmake

DESCRIPTION="zlib data compression library"
HOMEPAGE="https://github.com/zlib-ng/zlib-ng"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ZLIB"
SLOT="0"

#KEYWORDS="~amd64 ~x86"
IUSE="compat test"

src_prepare() {
	cmake_src_prepare
	sed "/LIB_INSTALL_DIR/s@/lib\"@/$(get_libdir)\"@" \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DZLIB_COMPAT="$(usex compat)"
		-DZLIB_ENABLE_TESTS="$(usex test)"
	)
	cmake_src_configure
}
