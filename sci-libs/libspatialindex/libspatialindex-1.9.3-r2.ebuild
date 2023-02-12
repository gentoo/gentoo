# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_P="spatialindex-src-${PV}"

DESCRIPTION="C++ implementation of R*-tree, an MVR-tree and a TPR-tree with C API"
HOMEPAGE="https://libspatialindex.org/
	https://github.com/libspatialindex/libspatialindex"
SRC_URI="https://github.com/libspatialindex/${PN}/releases/download/${PV}/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0/6"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="test? ( >=dev-cpp/gtest-1.10.0 )"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-respect-compiler-flags.patch
	"${FILESDIR}"/${P}-use-system-gtest.patch
)

src_prepare() {
	cmake_src_prepare

	sed -i -e 's/CMAKE_CXX_STANDARD 11/CMAKE_CXX_STANDARD 14/' \
		CMakeLists.txt || die "sed failed"
}

src_configure() {
	local mycmakeargs=(
		-DSIDX_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
