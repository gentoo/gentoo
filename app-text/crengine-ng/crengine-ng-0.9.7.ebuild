# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="Cross-platform library designed to implement e-book readers"
HOMEPAGE="https://gitlab.com/coolreader-ng/crengine-ng"
SRC_URI="https://gitlab.com/coolreader-ng/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="+png +jpeg +gif +svg +chm +harfbuzz +fontconfig +libunibreak +fribidi +zstd +libutf8proc lto static-libs"

CDEPEND="sys-libs/zlib
	png? ( media-libs/libpng:0 )
	jpeg? ( media-libs/libjpeg-turbo )
	>=media-libs/freetype-2.10.0
	harfbuzz? ( media-libs/harfbuzz:= )
	libunibreak? ( dev-libs/libunibreak:= )
	fribidi? ( dev-libs/fribidi )
	zstd? ( app-arch/zstd:= )
	libutf8proc? ( dev-libs/libutf8proc:= )
	fontconfig? ( media-libs/fontconfig )"

RDEPEND="${CDEPEND}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	${CDEPEND}"

src_configure() {
	CMAKE_USE_DIR="${S}"
	CMAKE_BUILD_TYPE="Release"
	local mycmakeargs=(
		-DCRE_BUILD_SHARED=ON
		-DCRE_BUILD_STATIC=$(usex static-libs)
		-DUSE_COLOR_BACKBUFFER=ON
		-DWITH_LIBPNG=$(usex png)
		-DWITH_LIBJPEG=$(usex jpeg)
		-DWITH_FREETYPE=ON
		-DWITH_HARFBUZZ=$(usex harfbuzz)
		-DWITH_LIBUNIBREAK=$(usex libunibreak)
		-DWITH_FRIBIDI=$(usex fribidi)
		-DWITH_ZSTD=$(usex zstd)
		-DWITH_UTF8PROC=$(usex libutf8proc)
		-DUSE_GIF=$(usex gif)
		-DUSE_NANOSVG=$(usex svg)
		-DUSE_CHM=$(usex chm)
		-DUSE_ANTIWORD=ON
		-DUSE_FONTCONFIG=$(usex fontconfig)
		-DUSE_SHASUM=OFF
		-DBUILD_TOOLS=OFF
		-DENABLE_UNITTESTING=OFF
		-DENABLE_LTO=$(usex lto)
	)
	cmake_src_configure
}
