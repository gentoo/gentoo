# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic

MY_P=Coin3D-coin-a4ce638f43bd

DESCRIPTION="A high-level 3D graphics toolkit, fully compatible with SGI Open Inventor 2.1"
HOMEPAGE="https://bitbucket.org/Coin3D/coin/wiki/Home"
SRC_URI="https://dev.gentoo.org/~reavertm/${MY_P}.tar.bz2"

LICENSE="|| ( GPL-2 PEL )"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="debug doc +exceptions javascript man openal qthelp test threads"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	man? ( doc )
	qthelp? ( doc )
"

RDEPEND="
	app-arch/bzip2
	dev-libs/expat
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/simage
	sys-libs/zlib
	virtual/opengl
	virtual/glu
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	javascript? ( dev-lang/spidermonkey:60 )
	openal? ( media-libs/openal )
"
DEPEND="${RDEPEND}
	dev-libs/boost:0
	x11-base/xorg-proto
	doc? (
		app-doc/doxygen
		qthelp? ( dev-qt/qthelp:5 )
	)
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.0a-cmake.patch
)

DOCS=(
	AUTHORS FAQ FAQ.legal NEWS THANKS docs/HACKING
)

src_configure() {
	use debug && append-cppflags -DCOIN_DEBUG=1

	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"

		-DCOIN_BUILD_SHARED_LIBS=ON
		-DCOIN_BUILD_TESTS=$(usex test)
		-DCOIN_BUILD_DOCUMENTATION=$(usex doc)

		-DCOIN_BUILD_INTERNAL_DOCUMENTATION=OFF
		-DCOIN_BUILD_DOCUMENTATION_MAN=$(usex man)
		-DCOIN_BUILD_DOCUMENTATION_QTHELP=$(usex qthelp)
		-DCOIN_BUILD_DOCUMENTATION_CHM=OFF

		-DCOIN_THREADSAFE=$(usex threads)
		-DHAVE_VRML97=ON
		-DCOIN_HAVE_JAVASCRIPT=$(usex javascript)
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
		-DHAVE_MULTIPLE_VERSION=ON

		-DCOIN_BUILD_SINGLE_LIB=ON
	)

	cmake-utils_src_configure
}

src_test() {
	pushd "${BUILD_DIR}/bin" > /dev/null || die
	./CoinTests -r detailed || die "Tests failed."
	popd > /dev/null || die
}
