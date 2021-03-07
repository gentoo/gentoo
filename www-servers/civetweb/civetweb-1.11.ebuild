# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

HOMEPAGE="https://github.com/civetweb/civetweb/"
DESCRIPTION="Embedded C/C++ web server"
SRC_URI="https://github.com/civetweb/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cxx +server ssl"

RDEPEND="ssl? ( dev-libs/openssl:0= )"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e 's|DESTINATION lib$|DESTINATION ${CMAKE_INSTALL_LIBDIR}|' \
		-i src/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=OFF
		-DBUILD_SHARED_LIBS=ON
		-DCIVETWEB_BUILD_TESTING=OFF
		-DCIVETWEB_ENABLE_LUA=OFF
		-DCIVETWEB_ENABLE_DUKTAPE=OFF
		-DCIVETWEB_ENABLE_CXX="$(usex cxx)"
		-DCIVETWEB_ENABLE_SERVER_EXECUTABLE="$(usex server)"
		-DCIVETWEB_ENABLE_SSL="$(usex ssl)"
	)

	cmake-utils_src_configure
}
