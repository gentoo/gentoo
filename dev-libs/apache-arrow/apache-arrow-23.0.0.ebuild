# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: upstream meson port is incomplete.
# https://github.com/apache/arrow/issues/45778
inherit cmake

# arrow.git: testing
ARROW_DATA_GIT_HASH=725fd4a4b12d01c53c98e80274c0b23aa8397082
# arrow.git: cpp/submodules/parquet-testing
PARQUET_DATA_GIT_HASH=a3d96a65e11e2bbca7d22a894e8313ede90a33a3

DESCRIPTION="A cross-language development platform for in-memory data"
HOMEPAGE="
	https://arrow.apache.org/
	https://github.com/apache/arrow/
"
SRC_URI="
	mirror://apache/arrow/arrow-${PV}/${P}.tar.gz
	test? (
		https://github.com/apache/parquet-testing/archive/${PARQUET_DATA_GIT_HASH}.tar.gz
			-> parquet-testing-${PARQUET_DATA_GIT_HASH}.tar.gz
		https://github.com/apache/arrow-testing/archive/${ARROW_DATA_GIT_HASH}.tar.gz
			-> arrow-testing-${ARROW_DATA_GIT_HASH}.tar.gz
	)
"
S="${WORKDIR}/${P}/cpp"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~riscv ~s390 ~x86"
IUSE="
	+brotli bzip2 +compute +dataset +json lz4 +parquet +re2 +snappy ssl
	test zlib zstd
"
REQUIRED_USE="
	test? (
		json
		parquet? ( zstd )
	)
	ssl? ( json )
"
RESTRICT="!test? ( test )"

RDEPEND="
	brotli? ( app-arch/brotli:= )
	bzip2? ( app-arch/bzip2:= )
	compute? ( dev-libs/libutf8proc:= )
	dataset? (
		dev-libs/libutf8proc:=
	)
	elibc_musl? ( sys-libs/timezone-data )
	lz4? ( app-arch/lz4:= )
	parquet? (
		dev-libs/libutf8proc:=
		dev-libs/thrift:=
		ssl? ( dev-libs/openssl:= )
	)
	re2? ( dev-libs/re2:= )
	snappy? ( app-arch/snappy:= )
	zlib? ( virtual/zlib:= )
	zstd? ( app-arch/zstd:= )
"
DEPEND="
	${RDEPEND}
	dev-cpp/xsimd
	>=dev-libs/boost-1.81.0
	json? ( dev-libs/rapidjson )
	test? (
		dev-cpp/gflags
		dev-cpp/gtest
	)
"

src_prepare() {
	# use Gentoo CXXFLAGS, specify docdir at src_configure.
	sed -i \
		-e '/SetupCxxFlags/d' \
		-e '/set(ARROW_DOC_DIR.*)/d' \
		CMakeLists.txt \
		|| die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DARROW_BUILD_STATIC=OFF
		-DARROW_BUILD_TESTS=$(usex test ON OFF)
		-DARROW_COMPUTE=$(usex compute ON OFF)
		-DARROW_CSV=ON
		-DARROW_DATASET=$(usex dataset ON OFF)
		-DARROW_DEPENDENCY_SOURCE=SYSTEM
		-DARROW_DEPENDENCY_USE_SHARED=ON
		-DARROW_DOC_DIR=share/doc/${PF}
		-DARROW_FILESYSTEM=ON
		-DARROW_HDFS=ON
		-DARROW_JEMALLOC=OFF
		-DARROW_JSON=$(usex json ON OFF)
		-DARROW_MIMALLOC=OFF
		-DARROW_PARQUET=$(usex parquet ON OFF)
		-DPARQUET_REQUIRE_ENCRYPTION=$(usex ssl ON OFF)
		-DARROW_USE_CCACHE=OFF
		-DARROW_USE_SCCACHE=OFF
		-DARROW_WITH_BROTLI=$(usex brotli ON OFF)
		-DARROW_WITH_BZ2=$(usex bzip2 ON OFF)
		-DARROW_WITH_LZ4=$(usex lz4 ON OFF)
		-DARROW_WITH_RE2=$(usex re2 ON OFF)
		-DARROW_WITH_SNAPPY=$(usex snappy ON OFF)
		-DARROW_WITH_ZLIB=$(usex zlib ON OFF)
		-DARROW_WITH_ZSTD=$(usex zstd ON OFF)
		-DCMAKE_CXX_STANDARD=17
	)
	cmake_src_configure
}

src_test() {
	local -x PARQUET_TEST_DATA="${WORKDIR}/parquet-testing-${PARQUET_DATA_GIT_HASH}/data"
	local -x ARROW_TEST_DATA="${WORKDIR}/arrow-testing-${ARROW_DATA_GIT_HASH}/data"
	cmake_src_test
}

src_install() {
	cmake_src_install
	if use test; then
		cd "${D}"/usr/$(get_libdir) || die
		rm -r cmake/ArrowTesting || die
		rm libarrow_testing* || die
		rm pkgconfig/arrow-testing.pc || die
	fi
}
