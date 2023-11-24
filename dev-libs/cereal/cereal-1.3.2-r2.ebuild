# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Header-only C++11 serialization library"
HOMEPAGE="https://uscilab.github.io/cereal/"
SRC_URI="https://github.com/USCiLab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-doc/doxygen )"
DEPEND="dev-libs/rapidjson"

src_prepare() {
	if ! use doc ; then
		sed -i -e '/add_subdirectory(doc/d' CMakeLists.txt || die
	fi

	# remove bundled rapidjson
	rm -r include/cereal/external/rapidjson || die 'could not remove bundled rapidjson'
	sed -e '/rapidjson/s|cereal/external/||' \
		-e 's/CEREAL_RAPIDJSON_NAMESPACE/rapidjson/g' \
		-i include/cereal/archives/json.hpp || die

	cmake_src_prepare
}

src_configure() {
	# TODO: drop bundled doctest, rapidxml (bug #792444)

	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)

		# Avoid Boost dependency
		-DSKIP_PERFORMANCE_COMPARISON=ON

		-DWITH_WERROR=OFF
	)

	# TODO: Enable if multilib?
	use test && mycmakeargs+=( -DSKIP_PORTABILITY_TEST=ON )

	cmake_src_configure
}
