# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Heavily optimized DEFLATE/zlib/gzip (de)compression"
HOMEPAGE="https://github.com/ebiggers/libdeflate"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ebiggers/libdeflate.git"
else
	SRC_URI="https://github.com/ebiggers/libdeflate/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+gzip static-libs +utils +zlib test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DLIBDEFLATE_BUILD_SHARED_LIB="yes"
		-DLIBDEFLATE_BUILD_STATIC_LIB="$(usex static-libs)"
		-DLIBDEFLATE_USE_SHARED_LIB="$(usex !static-libs)"

		-DLIBDEFLATE_COMPRESSION_SUPPORT="yes"
		-DLIBDEFLATE_DECOMPRESSION_SUPPORT="yes"

		-DLIBDEFLATE_BUILD_GZIP="$(usex gzip "$(usex utils)" )"
		-DLIBDEFLATE_GZIP_SUPPORT="$(usex gzip)"

		-DLIBDEFLATE_ZLIB_SUPPORT="$(usex zlib)"

		-DLIBDEFLATE_BUILD_TESTS="$(usex test)"
	)

	cmake_src_configure
}
