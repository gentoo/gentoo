# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/aseprite/aseprite-9999.ebuild,v 1.3 2013/08/10 15:00:11 tomwij Exp $

EAPI="5"

inherit cmake-utils flag-o-matic git-2

DESCRIPTION="Animated sprite editor & pixel art tool"
HOMEPAGE="http://www.aseprite.org"
EGIT_REPO_URI="git://github.com/dacap/${PN}.git"

LICENSE="GPL-2 FTL"
SLOT="0"
KEYWORDS=""

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
