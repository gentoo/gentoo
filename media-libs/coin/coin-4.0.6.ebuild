# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="High-level 3D graphics toolkit, fully compatible with SGI Open Inventor 2.1"
HOMEPAGE="https://github.com/coin3d/coin/wiki"
SRC_URI="https://github.com/coin3d/coin/releases/download/v${PV}/${P}-src.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="|| ( GPL-2 PEL )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="debug doc +exceptions openal qch test threads"

REQUIRED_USE="qch? ( doc )"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/bzip2
	dev-libs/expat
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/simage:=
	virtual/zlib:=
	virtual/opengl
	virtual/glu
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	openal? ( media-libs/openal )
"
DEPEND="${RDEPEND}
	dev-libs/boost:0
	x11-base/xorg-proto
"
BDEPEND="
	doc? (
		app-text/doxygen
		qch? ( dev-qt/qttools:6[assistant] )
	)
"

PATCHES=( "${FILESDIR}"/${PN}-4.0.3-find-qhelpgenerator.patch )

DOCS=( AUTHORS FAQ FAQ.legal NEWS THANKS docs/HACKING )

src_configure() {
	use debug && append-cppflags -DCOIN_DEBUG=1

	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"

		-DCOIN_BUILD_SHARED_LIBS=ON
		-DCOIN_BUILD_TESTS=$(usex test)
		-DCOIN_BUILD_DOCUMENTATION=$(usex doc)

		-DCOIN_BUILD_INTERNAL_DOCUMENTATION=OFF
		-DCOIN_BUILD_AWESOME_DOCUMENTATION=$(usex doc)
		-DCOIN_BUILD_DOCUMENTATION_MAN=$(usex doc)
		-DCOIN_BUILD_DOCUMENTATION_QTHELP=$(usex qch)
		-DCOIN_BUILD_DOCUMENTATION_CHM=OFF

		-DCOIN_THREADSAFE=$(usex threads)
		-DHAVE_VRML97=ON
		-DCOIN_HAVE_JAVASCRIPT=OFF
		-DHAVE_NODEKITS=ON
		-DHAVE_DRAGGERS=ON
		-DHAVE_MANIPULATORS=ON
		-DHAVE_SOUND=$(usex openal)
		-DHAVE_3DS_IMPORT_CAPABILITIES=ON
		-DUSE_EXTERNAL_EXPAT=ON
		-DUSE_EXCEPTIONS=$(usex exceptions)
		-DUSE_SUPERGLU=OFF

		-DFONTCONFIG_RUNTIME_LINKING=OFF
		-DFREETYPE_RUNTIME_LINKING=OFF
		-DLIBBZIP2_RUNTIME_LINKING=OFF
		-DOPENAL_RUNTIME_LINKING=OFF
		-DSIMAGE_RUNTIME_LINKING=OFF
		-DZLIB_RUNTIME_LINKING=OFF
		-DGLU_RUNTIME_LINKING=OFF
		-DSPIDERMONKEY_RUNTIME_LINKING=ON

		-DCOIN_VERBOSE=$(usex debug)
		-DHAVE_MULTIPLE_VERSION=OFF

		-DCOIN_BUILD_SINGLE_LIB=ON
	)
	use doc && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Git=ON )

	cmake_src_configure
}

src_test() {
	pushd "${BUILD_DIR}/bin" > /dev/null || die
	./CoinTests -r detailed || die "Tests failed."
	popd > /dev/null || die
}
