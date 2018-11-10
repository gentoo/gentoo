# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit flag-o-matic multilib toolchain-funcs

DESCRIPTION="Tcl bindings to OpenGL and other 3D libraries"
HOMEPAGE="http://www.tcl3d.org"
SRC_URI="http://www.tcl3d.org/download/${P}.distrib/${PN}-src-${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="
	dev-games/ode
	dev-lang/tk:0=
	dev-lang/tcl:0=
	media-libs/libsdl
	media-libs/ftgl
	virtual/opengl
	x11-libs/libXmu
"
DEPEND="${RDEPEND}
	>=dev-lang/swig-1.3.19"

S="${WORKDIR}/${PN}"

src_prepare() {
	TCL_VERSION=( $(echo 'puts [info tclversion]' | tclsh | tr '.' ' ') )
	einfo "Configuring for Tcl ${TCL_VERSION[0]}.${TCL_VERSION[1]}"
	sed -i \
		-e 's:^\(TCLMAJOR\) *=\(.*\)$:\1 = '${TCL_VERSION[0]}':' \
		-e 's:^\(TCLMINOR\) *=\(.*\)$:\1 = '${TCL_VERSION[1]}':' \
		config_Linux* || die

	# fix libSDL link
	sed -i \
		-e 's:-lSDL-1\.2:-lSDL:g' \
		tcl3dSDL/Makefile || die
}

src_compile() {
	append-flags -mieee-fp -ffloat-store -fPIC
	use debug || append-flags -DNDEBUG

	emake \
		INSTDIR="/usr" OPT="${CFLAGS}" CC="$(tc-getCC) -c" \
		CXX="$(tc-getCXX) -c" LD="$(tc-getLD)" \
		WRAP_FTGL=1 WRAP_SDL=1 WRAP_GL2PS=0 WRAP_ODE=1
}

src_install() {
	emake INSTDIR="${D}/usr" DESTDIR="${D}" INSTLIB="${D}/usr/$(get_libdir)" install
}
