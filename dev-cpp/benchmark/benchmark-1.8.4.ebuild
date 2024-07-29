# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="A microbenchmark support library"
HOMEPAGE="https://github.com/google/benchmark"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="debug doc test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-text/doxygen )
	test? ( >=dev-cpp/gtest-1.11.0 )"

src_configure() {
	local mycmakeargs=(
		-DBENCHMARK_ENABLE_ASSEMBLY_TESTS=OFF
		-DBENCHMARK_ENABLE_DOXYGEN=$(usex doc)
		-DBENCHMARK_ENABLE_GTEST_TESTS=$(usex test)
		-DBENCHMARK_ENABLE_TESTING=$(usex test)
		-DBENCHMARK_ENABLE_WERROR=OFF
		-DBENCHMARK_USE_BUNDLED_GTEST=OFF
	)

	use debug || append-cppflags -DNDEBUG

	cmake_src_configure
}
