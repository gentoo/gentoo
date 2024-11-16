# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Embeddable, persistent key-value store for fast storage"
HOMEPAGE="http://rocksdb.org https://github.com/facebook/rocksdb/"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="jemalloc numa static-libs tbb test"

RESTRICT="!test? ( test )"

DEPEND="
	app-arch/bzip2:=
	app-arch/lz4:=
	app-arch/snappy:=
	app-arch/zstd:=
	dev-cpp/gflags:=
	sys-libs/liburing:=
	sys-libs/zlib:=
	sys-process/numactl
	jemalloc? ( dev-libs/jemalloc:= )
	tbb? ( dev-cpp/tbb:= )
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/liburing.a/uring/' cmake/modules/Finduring.cmake || die
	sed -i -e '/find_program(CCACHE_FOUND ccache)/d' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DFAIL_ON_WARNINGS=OFF
		-DPORTABLE=1
		-DROCKSDB_BUILD_SHARED=$(usex static-libs OFF ON)
		-DWITH_ALL_TESTS=$(usex test)
		-DWITH_ASAN=OFF
		-DWITH_BENCHMARK=OFF
		-DWITH_BENCHMARK_TOOLS=OFF
		-DWITH_BZ2=ON
		-DWITH_CORE_TOOLS=ON
		-DWITH_DYNAMIC_EXTENSION=ON
		-DWITH_EXAMPLES=OFF
		-DWITH_FALLOCATE=ON
		-DWITH_GFLAGS=ON
		-DWITH_IOSTATS_CONTEXT=ON
		-DWITH_JEMALLOC=$(usex jemalloc ON OFF)
		-DWITH_JNI=OFF
		-DWITH_LIBURING=ON
		-DWITH_LZ4=ON
		-DWITH_MD_LIBRARY=ON
		-DWITH_NUMA=$(usex numa)
		-DWITH_SNAPPY=ON
		-DWITH_TBB=$(usex tbb)
		-DWITH_TOOLS=ON
		-DWITH_TRACE_TOOLS=ON
		-DWITH_TSAN=OFF
		-DWITH_ZLIB=ON
		-DWITH_ZSTD=ON
	)
	# -DWITH_TESTS option works only with debug build, needs to be set here
	# to not be overriden by cmake.eclass
	CMAKE_BUILD_TYPE=$(usex test Debug RelWithDebInfo) cmake_src_configure
}

src_install() {
	cmake_src_install

	if ! use static-libs; then
		rm "${ED}"/usr/$(get_libdir)/*.a || die
	fi
}
