# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A fast key-value storage library written at Google"
HOMEPAGE="https://github.com/google/leveldb"
SRC_URI="https://github.com/google/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~amd64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="+crc32c +snappy +tcmalloc test"

RESTRICT="!test? ( test )"

DEPEND="crc32c? ( dev-libs/crc32c )
	snappy? ( app-arch/snappy )
	tcmalloc? ( dev-util/google-perftools )"
RDEPEND="${DEPEND}"
BDEPEND="test? (
	dev-cpp/benchmark
	dev-cpp/gtest
)"

PATCHES=(
	"${FILESDIR}"/${PN}-1.23-system-testdeps.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DLEVELDB_BUILD_BENCHMARKS=OFF
		-DLEVELDB_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
