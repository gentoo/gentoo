# Copyright 2010-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Todo: google-breakpad?

EAPI=8

# src_install() currently requires this
CMAKE_MAKEFILE_GENERATOR="emake"

LUA_COMPAT=( lua5-{1..4} )

# Only needed by certain features
VIRTUALX_REQUIRED="manual"

WX_GTK_VER="3.0-gtk3"
inherit cmake desktop flag-o-matic lua-single readme.gentoo-r1 virtualx wxwidgets xdg-utils

DESCRIPTION="Cross-platform 3D realtime strategy game"
HOMEPAGE="https://megaglest.org/ https://github.com/MegaGlest/megaglest-source"
SRC_URI="https://github.com/MegaGlest/megaglest-source/releases/download/${PV}/megaglest-source-${PV}.tar.xz
	https://github.com/MegaGlest/megaglest-source/commit/789e1cdf.patch -> ${P}-789e1cdf.patch
	https://github.com/MegaGlest/megaglest-source/commit/5801b1fa.patch -> ${P}-5801b1fa.patch
	https://github.com/MegaGlest/megaglest-source/commit/412b37d0.patch -> ${P}-412b37d0.patch
	https://github.com/MegaGlest/megaglest-source/commit/e09ba53c.patch -> ${P}-e09ba53c.patch
	https://github.com/MegaGlest/megaglest-source/commit/fbd0cfb1.patch -> ${P}-fbd0cfb1.patch
"

LICENSE="GPL-3 BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="debug +editor fribidi cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 +streflop +tools +unicode wxuniversal +model-viewer videos"

REQUIRED_USE="${LUA_REQUIRED_USE}"

COMMON_DEPEND="
	${LUA_DEPS}
	dev-libs/libxml2
	dev-libs/xerces-c[icu]
	media-libs/fontconfig
	media-libs/freetype
	media-libs/ftgl
	media-libs/glew:=
	net-libs/libircclient
	media-libs/libpng:0
	media-libs/libsdl2[X,sound,joystick,opengl,video]
	media-libs/libvorbis
	media-libs/openal
	net-libs/gnutls:=
	net-libs/miniupnpc:=
	net-misc/curl
	sys-libs/zlib
	virtual/opengl
	virtual/glu
	virtual/jpeg:0=
	x11-libs/libX11
	x11-libs/libXext
	editor? ( x11-libs/wxGTK:${WX_GTK_VER}[X,opengl] )
	fribidi? ( dev-libs/fribidi )
	model-viewer? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
	videos? ( media-video/vlc )
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="
	${COMMON_DEPEND}
	~games-strategy/${PN}-data-${PV}
"

BDEPEND="sys-apps/help2man
	virtual/pkgconfig
	editor? ( ${VIRTUALX_DEPEND} )
	model-viewer? ( ${VIRTUALX_DEPEND} )"

PATCHES=(
	"${FILESDIR}/${PN}-3.11.1-cmake-lua.patch"

	# From Fedora and Arch
	"${FILESDIR}/${P}-underlink.patch"
	"${FILESDIR}/${P}-fix-lua-version-ordering.patch"
	"${FILESDIR}/${P}-multiple-definitions.patch"
	"${FILESDIR}/${P}-GLEW_ERROR_NO_GLX_DISPLAY.patch"
	"${FILESDIR}/${P}-help2man.patch"

	# Fix build with wxWidgets 3.2
	"${DISTDIR}/${P}-789e1cdf.patch"
	"${DISTDIR}/${P}-5801b1fa.patch"
	"${DISTDIR}/${P}-412b37d0.patch"
	"${DISTDIR}/${P}-e09ba53c.patch"
	"${FILESDIR}/${P}-fbd0cfb1.patch"
)

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="DO NOT directly edit glest.ini and glestkeys.ini but rather glestuser.ini
and glestuserkeys.ini in ~/.megaglest/ and create your user over-ride
values in these files.

If you have an older graphics card which only supports OpenGL 1.2, and the
game crashes when you try to play, try starting with 'megaglest --disable-vbo'
Some graphics cards may require setting Max Lights to 1.
"

src_prepare() {
	cmake_src_prepare

	if use editor || use model-viewer ; then
		setup-wxwidgets
	fi
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/926143
	# https://github.com/MegaGlest/megaglest-source/issues/275
	filter-lto

	if use cpu_flags_x86_sse3; then
		SSE=3
	elif use cpu_flags_x86_sse2; then
		SSE=2
	elif use cpu_flags_x86_sse; then
		SSE=1
	else
		SSE=0
	fi

	local mycmakeargs=(
		-DWANT_GIT_STAMP=OFF
		-DWANT_USE_FriBiDi="$(usex fribidi)"
		-DBUILD_MEGAGLEST_MAP_EDITOR="$(usex editor)"
		-DBUILD_MEGAGLEST_MODEL_IMPORT_EXPORT_TOOLS="$(usex tools)"
		-DBUILD_MEGAGLEST_MODEL_VIEWER="$(usex model-viewer)"
		-DWANT_USE_VLC="$(usex videos)"
		-DFORCE_LUA_VERSION="$(lua_get_version)"
		-DFORCE_MAX_SSE_LEVEL="${SSE}"
		-DWANT_USE_FTGL=ON
		-DWANT_STATIC_LIBS=OFF
		-DWANT_USE_STREFLOP="$(usex streflop)"
		-DwxWidgets_USE_STATIC=OFF
		-DwxWidgets_USE_UNICODE="$(usex unicode)"
		-DwxWidgets_USE_UNIVERSAL="$(usex wxuniversal)"

		$(usex debug "-DBUILD_MEGAGLEST_UPNP_DEBUG=ON -DwxWidgets_USE_DEBUG=ON" "")
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	# rebuilds some targets randomly without fast option
	emake -C "${BUILD_DIR}" DESTDIR="${D}" "$@" install/fast

	dodoc docs/{AUTHORS.source_code,CHANGELOG,README}.txt

	use editor &&
		make_desktop_entry ${PN}_editor "MegaGlest Map Editor"
	use model-viewer &&
		make_desktop_entry ${PN}_g3dviewer "MegaGlest Model Viewer"

	readme.gentoo_create_doc
	einstalldocs
}

pkg_postinst() {
	xdg_icon_cache_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_icon_cache_update
}
