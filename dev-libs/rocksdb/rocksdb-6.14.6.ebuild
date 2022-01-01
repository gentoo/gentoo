# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Embeddable, persistent key-value store for fast storage"
HOMEPAGE="http://rocksdb.org https://github.com/facebook/rocksdb/"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~x86"
IUSE="cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_sse4_2 jemalloc static-libs"

COMMON_DEPEND="
	app-arch/bzip2:=
	app-arch/lz4:=
	app-arch/snappy:=
	dev-python/zstandard:=
	sys-libs/zlib:=
	jemalloc? ( dev-libs/jemalloc:= )
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/gflags
"
RDEPEND="${COMMON_DEPEND}"

src_configure() {
	mycmakeargs=(
		-DFAIL_ON_WARNINGS=OFF
		-DFORCE_AVX2=$(usex cpu_flags_x86_avx2 ON OFF)
		-DFORCE_AVX=$(usex cpu_flags_x86_avx ON OFF)
		-DFORCE_SSE42=$(usex cpu_flags_x86_sse4_2 ON OFF)
		-DPORTABLE=ON
		-DWITH_JEMALLOC=$(usex jemalloc ON OFF)
		-DWITH_TESTS=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if ! use static-libs; then
		rm "${ED}"/usr/$(get_libdir)/*.a || die
	fi
}
