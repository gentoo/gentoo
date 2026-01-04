# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic cmake unpacker

DESCRIPTION="Tcl bindings to OpenGL and other 3D libraries"
HOMEPAGE="http://www.tcl3d.org"
SRC_URI="https://www.tcl3d.org/download/distributions/${P}.7z"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="sdl truetype"

RDEPEND="dev-lang/tcl:0=
	dev-lang/tk:0=
	x11-libs/libX11
	virtual/opengl
	virtual/glu
	truetype? ( media-libs/ftgl )
	sdl? ( media-libs/libsdl )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/swig
	$(unpacker_src_uri_depends)
"

PATCHES=( "${FILESDIR}"/${P}-cmake.patch )

src_prepare() {
	sed -i \
		-e "s|FTGLGlyph|FTGlyph|" \
		tcl3dFTGL/swigfiles/ftgl.i \
		|| die
	cmake_src_prepare
}

src_configure() {
	local _TCL_V=( $(echo 'puts [info tclversion]' | tclsh | tr '.' ' ') )
	local _TCL_FV="${_TCL_V[0]}.${_TCL_V[1]}"

	local tkPath=/usr/$(get_libdir)/tk${_TCL_FV}/include

	append-cppflags -I${tkPath}/generic -I${tkPath}/unix \
		$(pkg-config freetype2 --cflags) \
		$(pkg-config sdl --cflags)

	local mycmakeargs=(
		-Wno-dev
		-DTCL3D_BUILD_OGL=Yes
		-DTCL3D_BUILD_GAUGES=Yes
		-DTCL3D_BUILD_GL2PS=Yes
		-DTCL3D_BUILD_FTGL=$(usex truetype)
		-DTCL3D_BUILD_SDL=$(usex sdl)
	)
	cmake_src_configure
}
