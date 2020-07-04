# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop flag-o-matic xdg-utils

DESCRIPTION="Animated sprite editor & pixel art tool"
HOMEPAGE="https://www.aseprite.org"
SRC_URI="https://github.com/aseprite/aseprite/releases/download/v${PV}/Aseprite-v${PV}-Source.zip"

# See https://github.com/aseprite/aseprite#license
# Some bundled third-party packages built-in:
# gtest duktape modp_b64 simpleini
LICENSE="Aseprite-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="bundled-libs debug kde gtk3 test webp"
RESTRICT="bindist mirror !test? ( test )"

RDEPEND="
	!bundled-libs? ( media-libs/allegro:0[X,png] )
	gtk3? ( dev-cpp/gtkmm:3.0 )
	kde? (
		dev-qt/qtcore:5
		kde-frameworks/kio:5
	)
	webp? ( media-libs/libwebp )
	dev-libs/tinyxml
	media-libs/freetype
	media-libs/giflib:=
	media-libs/libpng:0=
	net-misc/curl
	sys-libs/zlib
	virtual/jpeg:0
	x11-libs/libX11
	x11-libs/pixman"
BDEPEND="
	app-arch/unzip
	gtk3? ( virtual/pkgconfig )
	webp? ( virtual/pkgconfig )"

DOCS=( docs/files/ase.txt
	docs/files/fli.txt
	docs/files/msk.txt
	docs/files/pic.txt
	docs/files/picpro.txt
	README.md )

S="${WORKDIR}"

PATCHES=( "${FILESDIR}/${PN}-1.1.7_type-punned_pointer.patch" )

src_prepare() {
	cmake_src_prepare

	# Fix to make flag-o-matic work.
	if use debug ; then
		sed -i '/-DNDEBUG/d' CMakeLists.txt || die
	fi
	# Fix shebang in thumbnailer
	sed -i -e 's:#!/usr/bin/sh:#!/bin/sh:' desktop/aseprite-thumbnailer || die
}

src_configure() {
	use debug && append-cppflags -DDEBUGMODE -D_DEBUG

	local mycmakeargs=(
		-DENABLE_UPDATER=OFF
		-DFULLSCREEN_PLATFORM=ON
		-DUSE_SHARED_ALLEGRO4=$(usex !bundled-libs)
		-DUSE_SHARED_CURL=ON
		-DUSE_SHARED_FREETYPE=ON
		-DUSE_SHARED_GIFLIB=ON
		-DUSE_SHARED_JPEGLIB=ON
		-DUSE_SHARED_LIBLOADPNG=ON
		-DUSE_SHARED_LIBPNG=ON
		-DUSE_SHARED_PIXMAN=ON
		-DUSE_SHARED_TINYXML=ON
		-DUSE_SHARED_ZLIB=ON
		-DUSE_SHARED_LIBWEBP=ON
		-DWITH_DESKTOP_INTEGRATION=ON
		-DWITH_GTK_FILE_DIALOG_SUPPORT="$(usex gtk3)"
		-DWITH_QT_THUMBNAILER="$(usex kde)"
		-DWITH_WEBP_SUPPORT="$(usex webp)"
		-DENABLE_TESTS="$(usex test)"
		-DKDE_INSTALL_USE_QT_SYS_PATHS=ON
	)
	cmake_src_configure
}

src_install() {
	newicon -s 64 "${S}/data/icons/ase64.png" "${PN}.png"
	cmake_src_install
}

pkg_postinst() {
	if use !bundled-libs ; then
		ewarn "Aseprite has been built with system-wide Allegro 4."
		ewarn "Please note that you will not be able to resize the main window."
		ewarn "For resizing support enable USE-flag bundled-libs and rebuild package."
	fi
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
