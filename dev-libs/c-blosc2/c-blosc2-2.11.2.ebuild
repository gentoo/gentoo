# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Blocking, shuffling and lossless compression library"
HOMEPAGE="
	https://www.blosc.org/c-blosc2/c-blosc2.html
	https://github.com/Blosc/c-blosc2/
"
SRC_URI="
	https://github.com/Blosc/c-blosc2/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ia64 ~ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="test +zlib +zstd"
REQUIRED_USE="test? ( zlib zstd )"
RESTRICT="!test? ( test )"

DEPEND="
	>=app-arch/lz4-1.7.5:=
	zlib? ( sys-libs/zlib:= )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="
	${DEPEND}
"

src_configure() {
	# remove bundled libs (just in case)
	rm -rf internal-complibs || die

	local mycmakeargs=(
		-DBUILD_STATIC=OFF
		-DBUILD_TESTS=$(usex test)
		-DBUILD_BENCHMARKS=OFF
		-DBUILD_EXAMPLES=OFF
		-DBUILD_FUZZERS=OFF
		-DDEACTIVATE_ZLIB=$(usex !zlib)
		-DDEACTIVATE_ZSTD=$(usex !zstd)
		-DPREFER_EXTERNAL_LZ4=ON
		-DPREFER_EXTERNAL_ZLIB=ON
		-DPREFER_EXTERNAL_ZSTD=ON

		# force regular zlib, at least for  the time being
		-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB_NG=ON

		# upstream overrides CMAKE_C_FLAGS, preventing ${CFLAGS} defaults
		# from applying, https://github.com/Blosc/c-blosc2/issues/433
		-DCMAKE_C_FLAGS="${CFLAGS}"
	)
	cmake_src_configure
}

src_test() {
	# Tests fail in parallel, https://github.com/Blosc/c-blosc2/issues/432
	MAKEOPTS=-j1 cmake_src_test
}
