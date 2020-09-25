# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Library for encoding and decoding .avif files"
HOMEPAGE="https://github.com/AOMediaCodec/libavif"
SRC_URI="https://github.com/AOMediaCodec/libavif/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+aom dav1d examples extras rav1e"

DEPEND="media-libs/libpng
	sys-libs/zlib
	virtual/jpeg
	aom? ( media-libs/libaom )
	dav1d? ( media-libs/dav1d )
	rav1e? ( media-video/rav1e )"
RDEPEND="${DEPEND}"
BDEPEND="dev-lang/nasm
	virtual/pkgconfig"

REQUIRED_USE="|| ( aom dav1d rav1e )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DAVIF_CODEC_AOM=$(usex aom ON OFF)
		-DAVIF_CODEC_DAV1D=$(usex dav1d ON OFF)
		-DAVIF_CODEC_LIBGAV1=OFF
		-DAVIF_CODEC_RAV1E=$(usex rav1e ON OFF)

		# Use system libraries.
		-DAVIF_LOCAL_ZLIBPNG=OFF
		-DAVIF_LOCAL_JPEG=OFF

		-DAVIF_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DAVIF_BUILD_APPS=$(usex extras ON OFF)
		-DAVIF_BUILD_TESTS=$(usex extras ON OFF)
	)

	cmake_src_configure
}
