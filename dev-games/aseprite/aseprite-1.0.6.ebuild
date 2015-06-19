# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/aseprite/aseprite-1.0.6.ebuild,v 1.1 2014/11/14 16:45:28 hasufell Exp $

EAPI="5"

inherit cmake-utils multilib toolchain-funcs flag-o-matic

DESCRIPTION="Animated sprite editor & pixel art tool"
HOMEPAGE="http://www.aseprite.org"
SRC_URI="https://github.com/aseprite/aseprite/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 FTL"
SLOT="0"
# giflib still unkeyworded
KEYWORDS=""

IUSE="debug memleak"

RDEPEND="dev-libs/tinyxml
	media-libs/allegro:0[X,png]
	>=media-libs/giflib-5.0
	media-libs/libpng:0
	sys-libs/zlib
	virtual/jpeg
	x11-libs/libX11
	x11-libs/pixman"
DEPEND="${RDEPEND}
	dev-cpp/gtest"

PATCHES=( "${FILESDIR}"/aseprite-0.9.5-underlinking.patch
	"${FILESDIR}"/${P}-obinary.patch
	"${FILESDIR}"/${P}-png_sizeof.patch )

DOCS=( docs/files/ase.txt
	docs/files/fli.txt
	docs/files/msk.txt
	docs/files/pic.txt
	docs/files/picpro.txt
	README.md )

src_prepare() {
	cmake-utils_src_prepare

	# Fix to make flag-o-matic work.
	if use debug ; then
		sed -i '/-DNDEBUG/d' CMakeLists.txt || die
	fi

	rm -r third_party/* || die
}

src_configure() {
	use debug && append-cppflags -DDEBUGMODE -D_DEBUG

	local mycmakeargs=(
		-DCURL_STATICLIB=OFF
		-DENABLE_UPDATER=OFF
		-DFULLSCREEN_PLATFORM=ON
		-DLIBPIXMAN_INCLUDE_DIR="$($(tc-getPKG_CONFIG) --variable=includedir pixman-1)/pixman-1"
		-DLIBPIXMAN_LIBRARY="$($(tc-getPKG_CONFIG) --variable=libdir pixman-1)/libpixman-1.so"
		-DUSE_SHARED_ALLEGRO4=ON
		-DUSE_SHARED_CURL=ON
		-DUSE_SHARED_GIFLIB=ON
		-DUSE_SHARED_GTEST=ON
		-DUSE_SHARED_JPEGLIB=ON
		-DUSE_SHARED_LIBLOADPNG=ON
		-DUSE_SHARED_LIBPNG=ON
		-DUSE_SHARED_PIXMAN=ON
		-DUSE_SHARED_TINYXML=ON
		-DUSE_SHARED_ZLIB=ON
		$(cmake-utils_use_enable memleak)
	)

	cmake-utils_src_configure
}
