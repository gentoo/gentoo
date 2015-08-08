# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cmake-utils flag-o-matic

DESCRIPTION="Animated sprite editor & pixel art tool"
HOMEPAGE="http://www.aseprite.org"
SRC_URI="http://aseprite.googlecode.com/files/aseprite-${PV}.tar.xz"

LICENSE="GPL-2 FTL"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="debug memleak static test"

RDEPEND="dev-libs/tinyxml
	media-libs/allegro:0[X,png]
	media-libs/giflib
	media-libs/libpng:0
	net-misc/curl
	sys-libs/zlib
	virtual/jpeg
	x11-libs/libX11"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"

PATCHES=( "${FILESDIR}"/aseprite-0.9.5-as-needed.patch
			"${FILESDIR}"/aseprite-0.9.5-underlinking.patch )

DOCS=( docs/quickref.odt
	docs/files/ase.txt
	docs/files/fli.txt
	docs/files/msk.txt
	docs/files/pic.txt
	docs/files/picpro.txt )

src_prepare() {
	cmake-utils_src_prepare

	# Fix to make flag-o-matic work.
	if use debug ; then
		sed -i '/-DNDEBUG/d' CMakeLists.txt || die
	fi

	# Only do a static link with Allegro if the user explicitly wants it.
	if ! use static ; then
		sed -i '/-DALLEGRO_STATICLINK/d' CMakeLists.txt || die
	fi

	# Remove long compiling tests for users with FEATURES="-test",
	# also removes the gtest dependency from the build.
	if ! use test ; then
		sed -i '/^find_unittests/d' src/CMakeLists.txt || die
		sed -i '/include_directories(.*third_party\/gtest.*)/d' src/CMakeLists.txt || die
		sed -i '/add_subdirectory(gtest)/d' third_party/CMakeLists.txt || die
	fi

	# Fix from https://465450.bugs.gentoo.org/attachment.cgi?id=345154
	# for "error: ‘png_sizeof’ was not declared in this scope".
	sed -i 's/png_\(sizeof\)/\1/g' src/file/png_format.cpp || die
}

src_configure() {
	use debug && append-cppflags -DDEBUGMODE -D_DEBUG

	local mycmakeargs

	mycmakeargs=(
		-DENABLE_UPDATER=OFF
		-DUSE_SHARED_ALLEGRO4=ON
		-DUSE_SHARED_CURL=ON
		-DUSE_SHARED_GIFLIB=ON
		-DUSE_SHARED_JPEGLIB=ON
		-DUSE_SHARED_LIBLOADPNG=ON
		-DUSE_SHARED_LIBPNG=ON
		-DUSE_SHARED_TINYXML=ON
		-DUSE_SHARED_ZLIB=ON
		-DFULLSCREEN_PLATFORM=ON
		$(cmake-utils_use_enable memleak)
		$(cmake-utils_use_use static STATIC_LIBC)
	)

	if use test ; then
		mycmakeargs+=(
			-DUSE_SHARED_GTEST=ON
		)
	fi

	cmake-utils_src_configure
}

pkg_postinst() {
	elog "Warning: aseprite might not choose the resolution correctly; so, you might need"
	elog "         to change the resolution once using the -resolution WxH[xBPP] argument."
	elog ""
	elog "         On subsequent runs, aseprite will remember the resolution you have set."
	elog ""
	elog "         For example: \`aseprite -resolution 1440x900\`"
}
