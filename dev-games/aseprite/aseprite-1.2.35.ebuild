# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop flag-o-matic xdg-utils

DESCRIPTION="Animated sprite editor & pixel art tool"
HOMEPAGE="https://www.aseprite.org"
SRC_URI="https://github.com/aseprite/aseprite/releases/download/v${PV}/Aseprite-v${PV}-Source.zip -> ${P}.zip
	x86? ( https://github.com/aseprite/skia/releases/download/m102-861e4743af/Skia-Linux-Release-x86.zip -> skia-x86.zip )
	amd64? ( https://github.com/aseprite/skia/releases/download/m102-861e4743af/Skia-Linux-Release-x64.zip -> skia-x86_64.zip )"

# See https://github.com/aseprite/aseprite#license
# Some bundled third-party packages built-in:
# gtest duktape modp_b64 simpleini
LICENSE="Aseprite-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

IUSE="debug kde lua test webp"
RESTRICT="bindist mirror !test? ( test )"

RDEPEND="
	kde? (
		dev-qt/qtcore:5
		kde-frameworks/kio:5
	)
	webp? ( media-libs/libwebp )
	app-text/cmark
	dev-libs/tinyxml[-stl]
	media-libs/fontconfig
	media-libs/freetype
	media-libs/giflib:=
	media-libs/harfbuzz:0=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	media-libs/mesa
	net-misc/curl
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/pixman"
BDEPEND="
	app-arch/unzip
	sys-devel/clang
	sys-libs/libcxx"

DOCS=( docs/ase-file-specs.md
	docs/gpl-palette-extension.md
	README.md )

S="${WORKDIR}"

src_unpack() {
	unpack "${P}.zip"
	mkdir -p deps/skia/ && cd deps/skia/ && unpack "skia-$(uname -m).zip"
}

src_prepare() {
	cmake_src_prepare

	# Fix to make flag-o-matic work.
	if use debug ; then
		sed -i '/-DNDEBUG/d' CMakeLists.txt || die
	fi
	# Fix shebang in thumbnailer
	sed -i -e 's:#!/usr/bin/sh:#!/bin/sh:' src/desktop/linux/aseprite-thumbnailer || die
}

src_configure() {
	use debug && append-cppflags -DDEBUGMODE -D_DEBUG

	local CC=clang
	local CXX=clang++

	local mycmakeargs=(
		-DCMAKE_CXX_FLAGS=-stdlib=libc++
		-DCMAKE_EXE_LINKER_FLAGS=-stdlib=libc++
		-DENABLE_CCACHE=OFF
		-DENABLE_DESKTOP_INTEGRATION=ON
		-DENABLE_MEMLEAK=$(usex debug)
		-DENABLE_QT_THUMBNAILER=$(usex kde)
		-DENABLE_SCRIPTING=$(usex lua)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_UPDATER=OFF
		-DENABLE_WEBP=$(usex webp)
		-DFULLSCREEN_PLATFORM=ON
		-DLAF_WITH_TESTS=$(usex test)
		-DSKIA_DIR="${S}/deps/skia"
		-DSKIA_LIBRARY="${S}/deps/skia/out/Release-$(usex amd64 "x64" "x86")/libskia.a"
		-DSKIA_LIBRARY_DIR="${S}/deps/skia/out/Release-$(usex amd64 "x64" "x86")"
		-DUNDO_TESTS=$(usex test)
		-DUSE_SHARED_CMARK=ON
		-DUSE_SHARED_CURL=ON
		-DUSE_SHARED_FREETYPE=ON
		-DUSE_SHARED_GIFLIB=ON
		-DUSE_SHARED_HARFBUZZ=ON
		-DUSE_SHARED_JPEGLIB=ON
		-DUSE_SHARED_LIBPNG=ON
		-DUSE_SHARED_PIXMAN=ON
		-DUSE_SHARED_TINYXML=ON
		-DUSE_SHARED_ZLIB=ON
	)
	cmake_src_configure
}

src_install() {
	newicon -s 64 "${S}/data/icons/ase64.png" "${PN}.png"
	cmake_src_install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
