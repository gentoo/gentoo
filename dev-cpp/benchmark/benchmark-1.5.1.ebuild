# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A microbenchmark support library"
HOMEPAGE="https://github.com/google/benchmark"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 -hppa ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DBENCHMARK_ENABLE_TESTING=$(usex test)
		-DBENCHMARK_ENABLE_GTEST_TESTS=OFF
		-DBENCHMARK_ENABLE_ASSEMBLY_TESTS=OFF
	)

	cmake_src_configure
}
