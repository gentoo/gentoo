# Copyright 1999-2026 Gentoo Authors
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

BDEPEND="doc? ( app-text/doxygen )
	test? ( dev-cpp/doctest )
"
DEPEND="dev-libs/rapidjson"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/1.3.2-clang-tuple.patch )

src_prepare() {
	if ! use doc ; then
		cmake_comment_add_subdirectory doc
	fi

	# remove bundled rapidjson (bug 792444)
	# rapidxml cannot be unbundled easily, see the bug for details.
	rm -r include/cereal/external/rapidjson || die 'could not remove bundled rapidjson'
	sed -e '/rapidjson/s|cereal/external/||' \
		-e 's/CEREAL_RAPIDJSON_NAMESPACE/rapidjson/g' \
		-i include/cereal/archives/json.hpp || die

	# remove bundled doctest
	rm unittests/doctest.h || die 'could not remove bundled doctest'
	sed -e 's/\"doctest\.h\"/<doctest\/doctest.h>/g' \
		-i unittests/common.hpp || die

	cmake_src_prepare
}

src_configure() {
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
