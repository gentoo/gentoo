# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Header-only C++11 serialization library"
HOMEPAGE="https://uscilab.github.io/cereal/"
SRC_URI="https://github.com/USCiLab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	if ! use doc ; then
		sed -i -e '/add_subdirectory(doc/d' CMakeLists.txt || die
	fi

	cmake_src_prepare
}

src_configure() {
	# TODO: drop bundled doctest, rapidjson, rapidxml (bug #792444)

	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)

		# Avoid Boost dependency
		-DSKIP_PERFORMANCE_COMPARISON=ON

		-DWITH_WERROR=OFF
	)

	cmake_src_configure
}
