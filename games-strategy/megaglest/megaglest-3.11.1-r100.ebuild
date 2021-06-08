# Copyright 2010-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# google-breakpad
# TODO: fribidi, libvorbis static

EAPI=7

# src_install() currently requires this
CMAKE_MAKEFILE_GENERATOR="emake"

LUA_COMPAT=( lua5-{1..2} )

# Only needed by certain features
VIRTUALX_REQUIRED="manual"

WX_GTK_VER="3.0"
inherit cmake desktop lua-single virtualx wxwidgets xdg-utils

DESCRIPTION="Cross-platform 3D realtime strategy game"
HOMEPAGE="https://megaglest.org/ https://github.com/MegaGlest/megaglest-source"
SRC_URI="https://github.com/MegaGlest/megaglest-source/releases/download/${PV}/megaglest-source-${PV}.tar.xz"

LICENSE="GPL-3 BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +editor fribidi cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 +streflop +tools +unicode wxuniversal +model-viewer videos"

REQUIRED_USE="${LUA_REQUIRED_USE}"

# Older versions of megaglest-data install into /usr/games
RDEPEND="${LUA_DEPS}
	~games-strategy/${PN}-data-${PV}
	>=games-strategy/${PN}-data-3.11.1-r1
	dev-libs/libxml2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libsdl[X,sound,joystick,opengl,video]
	media-libs/libvorbis
	media-libs/openal
	net-libs/gnutls
	sys-libs/zlib
	virtual/opengl
	virtual/glu
	x11-libs/libX11
	x11-libs/libXext
	editor? ( x11-libs/wxGTK:${WX_GTK_VER}[X,opengl] )
	fribidi? ( dev-libs/fribidi )
	model-viewer? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
	dev-libs/xerces-c[icu]
	media-libs/ftgl
	media-libs/glew:=
	media-libs/libpng:0
	net-libs/libircclient
	>=net-libs/miniupnpc-1.8:=
	net-misc/curl
	virtual/jpeg:0
	videos? ( media-video/vlc )"
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/help2man
	virtual/pkgconfig
	editor? ( ${VIRTUALX_DEPEND} )
	model-viewer? ( ${VIRTUALX_DEPEND} )"

PATCHES=(
	"${FILESDIR}"/${P}-static-build.patch
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-cmake-lua.patch
	"${FILESDIR}"/${P}-miniupnpc.patch
	"${FILESDIR}"/${P}-miniupnpc-api-version-16.patch
)

src_prepare() {
	cmake_src_prepare

	if use editor || use model-viewer ; then
		setup-wxwidgets
	fi
}

src_configure() {
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
		-DBUILD_MEGAGLEST_MAP_EDITOR=$(usex editor)
		-DBUILD_MEGAGLEST_MODEL_IMPORT_EXPORT_TOOLS=$(usex tools)
		-DBUILD_MEGAGLEST_MODEL_VIEWER=$(usex model-viewer)
		-DENABLE_FRIBIDI=$(usex fribidi)
		-DFORCE_LUA_VERSION="$(lua_get_version)"
		-DMAX_SSE_LEVEL_DESIRED="${SSE}"
		-DUSE_FTGL=ON
		-DWANT_STATIC_LIBS=OFF
		-DWANT_STREFLOP=$(usex streflop)
		-DWITH_VLC=$(usex videos)
		-DwxWidgets_USE_STATIC=OFF
		-DwxWidgets_USE_UNICODE=$(usex unicode)
		-DwxWidgets_USE_UNIVERSAL=$(usex wxuniversal)

		$(usex debug "-DBUILD_MEGAGLEST_UPNP_DEBUG=ON -DwxWidgets_USE_DEBUG=ON" "")
	)

	cmake_src_configure
}

src_compile() {
	if use editor || use model-viewer; then
		# work around parallel make issues - bug #561380
		MAKEOPTS="-j1 ${MAKEOPTS}" \
			virtx cmake_src_compile
	else
		cmake_src_compile
	fi
}

src_install() {
	# rebuilds some targets randomly without fast option
	emake -C "${BUILD_DIR}" DESTDIR="${D}" "$@" install/fast

	dodoc docs/{AUTHORS.source_code,CHANGELOG,README}.txt
	doicon -s 48 ${PN}.png

	use editor &&
		make_desktop_entry ${PN}_editor "MegaGlest Map Editor"
	use model-viewer &&
		make_desktop_entry ${PN}_g3dviewer "MegaGlest Model Viewer"
}

pkg_postinst() {
	einfo
	elog 'Note about Configuration:'
	elog 'DO NOT directly edit glest.ini and glestkeys.ini but rather glestuser.ini'
	elog 'and glestuserkeys.ini in ~/.megaglest/ and create your user over-ride'
	elog 'values in these files.'
	elog
	elog 'If you have an older graphics card which only supports OpenGL 1.2, and the'
	elog 'game crashes when you try to play, try starting with "megaglest --disable-vbo"'
	elog 'Some graphics cards may require setting Max Lights to 1.'
	einfo

	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
