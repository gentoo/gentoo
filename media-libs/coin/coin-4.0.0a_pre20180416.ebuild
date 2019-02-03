# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

MY_P=Coin3D-coin-8d1ca1a6ea23

DESCRIPTION="A high-level 3D graphics toolkit, fully compatible with SGI Open Inventor 2.1"
HOMEPAGE="https://bitbucket.org/Coin3D/coin/wiki/Home"
SRC_URI="https://dev.gentoo.org/~reavertm/${MY_P}.tar.bz2"

LICENSE="|| ( GPL-2 PEL )"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="debug doc javascript openal qthelp simage test threads"

RDEPEND="
	app-arch/bzip2
	dev-libs/expat
	media-libs/fontconfig
	media-libs/freetype:2
	sys-libs/zlib
	virtual/opengl
	virtual/glu
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	javascript? ( dev-lang/spidermonkey:0 )
	openal? ( media-libs/openal )
	simage? ( media-libs/simage )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	doc? (
		app-doc/doxygen
		qthelp? ( dev-qt/qthelp:5 )
	)
"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.0a-gcc-7.patch
)

DOCS=(
	AUTHORS FAQ FAQ.legal NEWS README RELNOTES THANKS docs/HACKING
)

src_configure() {
	use debug && append-cppflags -DCOIN_DEBUG=1

	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DCOIN_BUILD_DOCUMENTATION=$(usex doc)
		-DCOIN_BUILD_SHARED_LIBS=ON
		-DCOIN_BUILD_SINGLE_LIB=ON
		-DCOIN_BUILD_TESTS=$(usex test)
		-DCOIN_HAVE_JAVASCRIPT=$(usex javascript)
		-DCOIN_MULTIPLE_VERSION=OFF
		-DCOIN_QT_HELP=$(usex doc)
		-DCOIN_THREADSAFE=$(usex threads)
		-DCOIN_VERBOSE=$(usex debug)
		-DHAVE_3DS_IMPORT_CAPABILITIES=ON
		-DHAVE_DRAGGERS=ON
		-DHAVE_MAN=OFF
		-DHAVE_MANIPULATORS=ON
		-DHAVE_NODEKITS=ON
		-DHAVE_SOUND=$(usex openal)
		-DHAVE_VRML97=ON
		-DSIMAGE_RUNTIME_LINKING=OFF
		-DUSE_EXTERNAL_EXPAT=ON
	)

	cmake-utils_src_configure
}

src_test() {
	pushd "${BUILD_DIR}/testsuite" > /dev/null || die
	./CoinTests || die "Tests failed."
	popd > /dev/null || die
}
