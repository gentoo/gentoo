# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="A high-level 3D graphics toolkit, fully compatible with SGI Open Inventor 2.1"
HOMEPAGE="https://github.com/coin3d/coin/wiki"
SRC_URI="https://github.com/coin3d/coin/releases/download/v${PV}/${P}-src.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="|| ( GPL-2 PEL )"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
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
	doc? ( qthelp? ( dev-qt/qthelp:5 ) )
"
BDEPEND="doc? ( app-text/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.0-0007-Locate-slotted-qhelpgenerator.patch
)

DOCS=(
	AUTHORS FAQ FAQ.legal NEWS THANKS docs/HACKING
)

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/859832
	# https://github.com/coin3d/coin/issues/521
	filter-lto

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
		-DHAVE_MULTIPLE_VERSION=OFF

		-DCOIN_BUILD_SINGLE_LIB=ON
	)

	cmake_src_configure
}

src_test() {
	pushd "${BUILD_DIR}/bin" > /dev/null || die
	./CoinTests -r detailed || die "Tests failed."
	popd > /dev/null || die
}
