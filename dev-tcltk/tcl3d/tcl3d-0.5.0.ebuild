# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Tcl bindings to OpenGL and other 3D libraries"
HOMEPAGE="http://www.tcl3d.org"
SRC_URI="http://www.tcl3d.org/download/${P}.distrib/${PN}-src-${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	>=dev-lang/swig-1.3.38:0=
	dev-lang/tk:0=
	dev-lang/tcl:0=
	dev-games/ode
	dev-games/openscenegraph
	media-libs/libsdl
	media-libs/ftgl
	virtual/opengl
	x11-libs/libXmu
"

S="${WORKDIR}/${PN}"
PATCHES=( "${FILESDIR}/${P}-include-tk-dir-and-permissive.patch" )

src_prepare() {
	default

	local _TCL_V=( $(echo 'puts [info tclversion]' | tclsh | tr '.' ' ') )
	local _TCL_FV="${_TCL_V[0]}.${_TCL_V[1]}"

	einfo "Configuring for Tcl ${_TCL_FV}"
	sed -i \
		-e 's:^\(TCLMAJOR\) *=\(.*\)$:\1 = '${_TCL_V[0]}':' \
		-e 's:^\(TCLMINOR\) *=\(.*\)$:\1 = '${_TCL_V[1]}':' \
		config_Linux* || die

	# Fix libSDL link
	sed -i -e 's:-lSDL-1\.2:-lSDL:g' tcl3dSDL/Makefile || die
}

src_compile() {
	append-flags -fPIC
	use debug || append-flags -DNDEBUG

	# Restricting build to -j1 since it seems that if we build it in parallel,
	# it fails with the "tcl3dOsg" project attempting to import glewdefs.i,
	# and not finding it.
	emake \
		-j1 \
		INSTDIR="/usr" \
		OPT="${CFLAGS}" \
		CC="$(tc-getCC) -c" \
		CXX="$(tc-getCXX) -c" \
		LD="$(tc-getLD)" \
		WRAP_FTGL=1 \
		WRAP_SDL=1 \
		WRAP_GL2PS=0 \
		WRAP_ODE=1
}

src_install() {
	emake INSTDIR="${D}/usr" DESTDIR="${D}" INSTLIB="${D}/usr/$(get_libdir)" install
}
