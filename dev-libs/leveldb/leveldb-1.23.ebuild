# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

GTEST_COMMIT="662fe38e44900c007eccb65a5d2ea19df7bd520e"
GTEST_VERSION="1.11.0_pre20210513"
BENCHMARK_COMMIT="7d0d9061d83b663ce05d9de5da3d5865a3845b79"
BENCHMARK_VERSION="1.5.5_pre20210511"

DESCRIPTION="Fast key-value storage library written at Google"
HOMEPAGE="https://github.com/google/leveldb"
SRC_URI="
	https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? (
		https://github.com/google/googletest/archive/${GTEST_COMMIT}.tar.gz
			-> gtest-${GTEST_VERSION}.tar.gz
		https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT}.tar.gz
			-> benchmark-${BENCHMARK_VERSION}.tar.gz
	)
"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+snappy +tcmalloc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/crc32c
	snappy? ( app-arch/snappy:= )
	tcmalloc? ( dev-util/google-perftools:= )
"
DEPEND="${RDEPEND}"

src_prepare() {
	if use test; then
		rm -r third_party/{googletest,benchmark} || die
		ln -s "../../googletest-${GTEST_COMMIT}" third_party/googletest || die
		ln -s "../../benchmark-${BENCHMARK_COMMIT}" third_party/benchmark || die
	fi
	sed -e 's/-Werror //' -i CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DHAVE_CRC32C=ON
		-DHAVE_SNAPPY=$(usex snappy)
		-DHAVE_TCMALLOC=$(usex tcmalloc)
		-DLEVELDB_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	TEST_TMPDIR="${T}" TEMP="${T}" cmake_src_test
}
