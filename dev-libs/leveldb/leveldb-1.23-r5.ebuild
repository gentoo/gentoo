# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A fast key-value storage library written at Google"
HOMEPAGE="https://github.com/google/leveldb"
SRC_URI="https://github.com/google/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="+snappy +tcmalloc test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/crc32c
	snappy? ( app-arch/snappy:= )
	tcmalloc? ( dev-util/google-perftools:=[-minimal] )
"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-cpp/gtest )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.23-system-testdeps.patch
	"${FILESDIR}"/${PN}-1.23-remove-benchmark-dep.patch
)

src_prepare() {
	sed -e '/fno-rtti/d' -i CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD=14 # C++14 or later required for >=gtest-1.13.0
		-DHAVE_CRC32C=ON
		-DLEVELDB_BUILD_BENCHMARKS=OFF
		-DHAVE_SNAPPY=$(usex snappy)
		-DHAVE_TCMALLOC=$(usex tcmalloc)
		-DLEVELDB_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	TEST_TMPDIR="${T}" TEMP="${T}" cmake_src_test
}
