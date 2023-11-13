# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Embeddable, persistent key-value store for fast storage"
HOMEPAGE="http://rocksdb.org https://github.com/facebook/rocksdb/"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_sse4_2 jemalloc numa static-libs tbb test"

# tests fail in this version
RESTRICT="test"

DEPEND="
	app-arch/bzip2:=
	app-arch/lz4:=
	app-arch/snappy:=
	app-arch/zstd:=
	dev-cpp/gflags
	sys-libs/liburing:=
	sys-libs/zlib:=
	sys-process/numactl
	jemalloc? ( dev-libs/jemalloc:= )
	tbb? ( dev-cpp/tbb:= )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-6.14.6-gcc13.patch
)

src_prepare() {
	sed -i -e 's/liburing.a/uring/' cmake/modules/Finduring.cmake || die
	sed -i -e '/find_program(CCACHE_FOUND ccache)/d' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DFAIL_ON_WARNINGS=OFF
		-DFORCE_AVX2=$(usex cpu_flags_x86_avx2 ON OFF)
		-DFORCE_AVX=$(usex cpu_flags_x86_avx ON OFF)
		-DFORCE_SSE42=$(usex cpu_flags_x86_sse4_2 ON OFF)
		-DPORTABLE=ON
		-DWITH_BZ2=ON
		-DWITH_CORE_TOOLS=ON
		-DWITH_DYNAMIC_EXTENSION=ON
		-DWITH_GFLAGS=ON
		-DWITH_JEMALLOC=$(usex jemalloc ON OFF)
		-DWITH_JNI=OFF
		-DWITH_LIBRADOS=OFF
		-DWITH_LIBURING=ON
		-DWITH_LZ4=ON
		-DWITH_MD_LIBRARY=ON
		-DWITH_NUMA=$(usex numa)
		-DWITH_SNAPPY=ON
		-DWITH_TBB=$(usex tbb)
		-DWITH_ALL_TESTS=$(usex test)
		-DWITH_TESTS=$(usex test)
		-DWITH_TOOLS=ON
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
