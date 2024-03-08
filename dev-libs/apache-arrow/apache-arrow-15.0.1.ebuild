# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# arrow.git: testing
ARROW_DATA_GIT_HASH=ad82a736c170e97b7c8c035ebd8a801c17eec170
# arrow.git: cpp/submodules/parquet-testing
PARQUET_DATA_GIT_HASH=d69d979223e883faef9dc6fe3cf573087243c28a

DESCRIPTION="A cross-language development platform for in-memory data."
HOMEPAGE="
	https://arrow.apache.org/
	https://github.com/apache/arrow/
"
SRC_URI="
	mirror://apache/arrow/arrow-${PV}/${P}.tar.gz
	test? (
		https://github.com/apache/parquet-testing/archive/${PARQUET_DATA_GIT_HASH}.tar.gz
			-> ${PN}-parquet-data-${PARQUET_DATA_GIT_HASH}.tar.gz
		https://github.com/apache/arrow-testing/archive/${ARROW_DATA_GIT_HASH}.tar.gz
			-> ${PN}-arrow-data-${ARROW_DATA_GIT_HASH}.tar.gz
	)
"
S="${WORKDIR}/${P}/cpp"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~hppa ~riscv"
IUSE="brotli bzip2 compute dataset +json lz4 parquet re2 snappy ssl test zlib zstd"
RESTRICT="!test? ( test )"

RDEPEND="
	brotli? ( app-arch/brotli:= )
	bzip2? ( app-arch/bzip2:= )
	compute? ( dev-libs/libutf8proc:= )
	dataset? (
		dev-libs/libutf8proc:=
	)
	lz4? ( app-arch/lz4:= )
	parquet? (
		dev-libs/libutf8proc:=
		dev-libs/thrift:=
		ssl? ( dev-libs/openssl:= )
	)
	re2? ( dev-libs/re2:= )
	snappy? ( app-arch/snappy:= )
	zlib? ( sys-libs/zlib:= )
	zstd? ( app-arch/zstd:= )
"
DEPEND="${RDEPEND}
	dev-cpp/xsimd
	>=dev-libs/boost-1.81.0
	json? ( dev-libs/rapidjson )
	test? (
		dev-cpp/gflags
		dev-cpp/gtest
	)
"

REQUIRED_USE="
	test? (
		json
		parquet? ( zstd )
	)
	ssl? ( json )
"

PATCHES=(
	"${FILESDIR}/${PN}-11.0.0-shared-lz4.patch"
	"${FILESDIR}/${PN}-14.0.1-gcc14.patch"
	# upstream backports
	"${FILESDIR}/${PN}-15.0.1-32bit.patch"
)

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
		-DARROW_BUILD_TESTS=$(usex test)
		-DARROW_COMPUTE=$(usex compute)
		-DARROW_CSV=ON
		-DARROW_DATASET=$(usex dataset)
		-DARROW_DEPENDENCY_SOURCE=SYSTEM
		-DARROW_DOC_DIR=share/doc/${PF}
		-DARROW_FILESYSTEM=ON
		-DARROW_HDFS=ON
		-DARROW_JEMALLOC=OFF
		-DARROW_JSON=$(usex json)
		-DARROW_PARQUET=$(usex parquet)
		-DPARQUET_REQUIRE_ENCRYPTION=$(usex ssl)
		-DARROW_USE_CCACHE=OFF
		-DARROW_USE_SCCACHE=OFF
		-DARROW_WITH_BROTLI=$(usex brotli)
		-DARROW_WITH_BZ2=$(usex bzip2)
		-DARROW_WITH_LZ4=$(usex lz4)
		-DARROW_WITH_RE2=$(usex re2)
		-DARROW_WITH_SNAPPY=$(usex snappy)
		-DARROW_WITH_ZLIB=$(usex zlib)
		-DARROW_WITH_ZSTD=$(usex zstd)
		-DCMAKE_CXX_STANDARD=17
	)
	cmake_src_configure
}

src_test() {
	export PARQUET_TEST_DATA="${WORKDIR}/parquet-testing-${PARQUET_DATA_GIT_HASH}/data"
	export ARROW_TEST_DATA="${WORKDIR}/arrow-testing-${ARROW_DATA_GIT_HASH}/data"
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
