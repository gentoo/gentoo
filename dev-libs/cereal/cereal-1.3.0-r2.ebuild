# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Header-only C++11 serialization library"
HOMEPAGE="https://uscilab.github.io/cereal/"
SRC_URI="
	https://github.com/USCiLab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~expeditioneer/patches/${P}-fix-doctest.patch"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="+doc test"

RESTRICT="!test? ( test )"

DEPEND="test? ( dev-libs/boost )"

PATCHES=( "${DISTDIR}/${P}-fix-doctest.patch" )

src_prepare() {
	sed -i -e '/set(CMAKE_CXX_FLAGS "-Wall -g -Wextra -Wshadow -pedantic -Wold-style-cast ${CMAKE_CXX_FLAGS}")/d' CMakeLists.txt || die

	if ! use doc ; then
		sed -i -e '/add_subdirectory(doc/d' CMakeLists.txt || die
	fi

	cmake_src_prepare
}

src_configure() {
	local CMAKE_BUILD_TYPE="Release"

	local mycmakeargs=(
		-DJUST_INSTALL_CEREAL=$(usex !test)
		-DSKIP_PORTABILITY_TEST=ON
		-DWITH_WERROR=OFF
	)
	cmake_src_configure
}
