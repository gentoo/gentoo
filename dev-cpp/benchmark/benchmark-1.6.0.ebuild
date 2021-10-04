# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A microbenchmark support library"
HOMEPAGE="https://github.com/google/benchmark"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"
IUSE="debug test"

RESTRICT="!test? ( test )"

# Version not in the tree yet
#BDEPEND="test? ( >=dev-cpp/gtest-1.11.0 )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.6-system_testdeps.patch
	"${FILESDIR}"/${PN}-1.6.0-disable_Werror.patch
	"${FILESDIR}"/${PN}-1.6.0-versioned_docdir.patch
)

src_configure() {
	local mycmakeargs=(
		-DBENCHMARK_ENABLE_TESTING=$(usex test)
		-DBENCHMARK_ENABLE_GTEST_TESTS=OFF
		-DBENCHMARK_ENABLE_ASSEMBLY_TESTS=OFF
	)

	use debug || append-cppflags -DNDEBUG

	cmake_src_configure
}
