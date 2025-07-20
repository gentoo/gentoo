# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake dot-a edo xdg

DESCRIPTION="Fast Light GUI Toolkit"
HOMEPAGE="https://www.fltk.org/"
SRC_URI="https://github.com/fltk/fltk/releases/download/release-${PV}/${P}-source.tar.bz2"

LICENSE="FLTK LGPL-2 MIT ZLIB"
SLOT="1/$(ver_cut 1-2)" # README.abi-version.txt
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="+X +cairo +dbus doc examples opengl static-libs test wayland"
REQUIRED_USE="
	|| ( X wayland )
	wayland? ( cairo )
"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	sys-libs/zlib:=
	X? (
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXfixes
		x11-libs/libXinerama
		!cairo? (
			media-libs/fontconfig
			x11-libs/libXft
			x11-libs/libXrender
		)
	)
	cairo? (
		dev-libs/glib:2
		x11-libs/cairo
		x11-libs/pango[X?]
	)
	opengl? (
		media-libs/glu
		media-libs/libglvnd[X]
	)
	wayland? (
		dev-libs/wayland
		gui-libs/libdecor
		x11-libs/libxkbcommon
		dbus? ( sys-apps/dbus )
	)
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
	wayland? ( dev-libs/wayland-protocols )
"
BDEPEND="
	doc? ( app-text/doxygen )
	wayland? ( dev-util/wayland-scanner )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.1-fltk-config.patch
	"${FILESDIR}"/${PN}-1.4.1-tests-odr.patch
	"${FILESDIR}"/${PN}-1.4.3-no-games.patch
)

src_prepare() {
	cmake_src_prepare

	# fluid can optionally use html docs at runtime, adjust path
	sed -i "s|\${FLTK_DOCDIR}/fltk|&-${PVR}/html|" CMake/export.cmake || die
}

src_configure() {
	lto-guarantee-fat

	local mycmakeargs=(
		-DFLTK_BACKEND_WAYLAND=$(usex wayland)
		-DFLTK_BACKEND_X11=$(usex X)
		-DFLTK_BUILD_FLUID=yes
		-DFLTK_BUILD_FLUID_DOCS=no
		-DFLTK_BUILD_GL=$(usex opengl)
		-DFLTK_BUILD_HTML_DOCS=$(usex doc)
		-DFLTK_BUILD_PDF_DOCS=no
		-DFLTK_BUILD_SHARED_LIBS=yes
		-DFLTK_BUILD_TEST=$(usex test)
		-DFLTK_GRAPHICS_CAIRO=$(usex cairo)
		-DFLTK_OPTION_STD=yes # will be removed & forced ON in fltk-1.5
		$(usev wayland -DFLTK_USE_DBUS=$(usex dbus))
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile all $(usev doc docs)
}

src_test() {
	# same that upstream's CI does except with the shared version
	edo "${BUILD_DIR}"/bin/test/unittests-shared --core
}

src_install() {
	local DOCS=(
		ANNOUNCEMENT CHANGES* CREDITS.txt README*
		$(usev examples)
		# simpler than using -DFLTK_INSTALL_HTML_DOCS for the location
		$(usev doc "${BUILD_DIR}"/documentation/html)
	)
	cmake_src_install

	# currently no option to disable building static libs
	use static-libs || rm -- "${ED}"/usr/$(get_libdir)/*.a || die

	strip-lto-bytecode
}
