# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Cross-platform library designed to implement e-book readers"
HOMEPAGE="https://gitlab.com/coolreader-ng/crengine-ng"
SRC_URI="https://gitlab.com/coolreader-ng/${PN}/-/archive/${PV}/${P}.tar.bz2
	test? ( mirror://gnu/freefont/freefont-otf-20120503.tar.gz )"

LICENSE="GPL-2+"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+png +jpeg webp jpegxl +gif +svg +chm +harfbuzz +fontconfig +libunibreak +fribidi +zstd +xxhash +libutf8proc static-libs test"

RESTRICT="!test? ( test )"

CDEPEND="virtual/zlib:=
	png? ( media-libs/libpng:0 )
	jpeg? ( media-libs/libjpeg-turbo )
	webp? ( media-libs/libwebp )
	jpegxl? ( media-libs/libjxl )
	>=media-libs/freetype-2.10.0
	harfbuzz? ( media-libs/harfbuzz:=[truetype] )
	libunibreak? ( dev-libs/libunibreak:= )
	fribidi? ( dev-libs/fribidi )
	zstd? ( app-arch/zstd:= )
	xxhash? ( dev-libs/xxhash )
	libutf8proc? ( dev-libs/libutf8proc:= )
	fontconfig? ( media-libs/fontconfig )"

RDEPEND="${CDEPEND}"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest
		app-arch/zip )
"
BDEPEND=">=dev-build/cmake-3.14
	virtual/pkgconfig
	${CDEPEND}"

src_prepare() {
	cmake_src_prepare
	if use test; then
		mkdir -p "${BUILD_DIR}/crengine/tests/fonts/"
		cp -p "${WORKDIR}/freefont-20120503/"*.otf "${BUILD_DIR}/crengine/tests/fonts/"
	fi
}

src_configure() {
	CMAKE_BUILD_TYPE="Release"
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex static-libs "OFF" "ON")
		-DUSE_COLOR_BACKBUFFER=ON
		-DWITH_LIBPNG=$(usex png)
		-DWITH_LIBJPEG=$(usex jpeg)
		-DWITH_LIBWEBP=$(usex webp)
		-DWITH_LIBJXL=$(usex jpegxl)
		-DWITH_FREETYPE=ON
		-DWITH_HARFBUZZ=$(usex harfbuzz)
		-DWITH_LIBUNIBREAK=$(usex libunibreak)
		-DWITH_FRIBIDI=$(usex fribidi)
		-DWITH_ZSTD=$(usex zstd)
		-DWITH_XXHASH=$(usex xxhash)
		-DWITH_UTF8PROC=$(usex libutf8proc)
		-DUSE_GIF=$(usex gif)
		-DUSE_NANOSVG=$(usex svg)
		-DUSE_CHM=$(usex chm)
		-DUSE_ANTIWORD=ON
		-DWITH_FONTCONFIG=$(usex fontconfig)
		-DUSE_SHASUM=OFF
		-DUSE_MD4C=ON
		-DBUILD_TOOLS=OFF
		-DENABLE_UNITTESTING=$(usex test)
		-DOFFLINE_BUILD_MODE=ON
	)
	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}/crengine/tests"
	./unittests
}
