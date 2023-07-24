# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Blocking, shuffling and lossless compression library"
HOMEPAGE="
	https://www.blosc.org/
	https://github.com/Blosc/c-blosc/
"
SRC_URI="
	https://github.com/Blosc/c-blosc/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="+lz4 +snappy test zlib zstd"
RESTRICT="!test? ( test )"

DEPEND="
	lz4? ( >=app-arch/lz4-1.7.5:= )
	snappy? ( app-arch/snappy:= )
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
		-DBUILD_FUZZERS=OFF
		-DDEACTIVATE_LZ4=$(usex !lz4)
		-DDEACTIVATE_SNAPPY=$(usex !snappy)
		-DDEACTIVATE_ZLIB=$(usex !zlib)
		-DDEACTIVATE_ZSTD=$(usex !zstd)
		-DPREFER_EXTERNAL_LZ4=ON
		# snappy is always external
		-DPREFER_EXTERNAL_ZLIB=ON
		-DPREFER_EXTERNAL_ZSTD=ON
	)
	cmake_src_configure
}
