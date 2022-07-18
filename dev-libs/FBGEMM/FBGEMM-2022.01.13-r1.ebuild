# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit python-any-r1 flag-o-matic cmake

CommitId=135412d2646f3bd753c8f1cfd33616110bbccd27

DESCRIPTION="Facebook GEneral Matrix Multiplication"
HOMEPAGE="https://github.com/pytorch/FBGEMM"
SRC_URI="https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="
	~dev-libs/asmjit-2021.11.13
	dev-libs/cpuinfo
"
RDEPEND="${DEPEND}"
BDEPEND="
	test? ( dev-cpp/gtest )
	${PYTHON_DEPS}
"
RESTRICT="!test? ( test )"

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	# Bug #855668
	filter-lto

	rm test/RowWiseSparseAdagradFusedTest.cc || die
	rm test/SparseAdagradTest.cc || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DFBGEMM_LIBRARY_TYPE=shared
		-DFBGEMM_BUILD_BENCHMARKS=OFF
		-DFBGEMM_BUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}
