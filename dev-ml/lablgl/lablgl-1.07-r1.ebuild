# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a toolchain-funcs

DESCRIPTION="Objective CAML interface for OpenGL"
HOMEPAGE="https://github.com/garrigue/lablgl"
SRC_URI="https://github.com/garrigue/lablgl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="doc glut +ocamlopt tk"

RDEPEND="
	>=dev-lang/ocaml-4.14:=[ocamlopt?]
	dev-ml/camlp-streams
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libX11
	virtual/opengl
	virtual/glu
	glut? ( media-libs/freeglut )
	tk? (
		>=dev-lang/tcl-8.3:0=
		>=dev-lang/tk-8.3:0=
		dev-ml/labltk:=
	)
"
DEPEND="
	${RDEPEND}
	dev-ml/findlib
"

PATCHES=( "${FILESDIR}"/${PN}-1.06-makefile.patch )

src_configure() {
	lto-guarantee-fat
	# make configuration file
	echo "BINDIR=/usr/bin" > Makefile.config || die
	echo "GLLIBS = -lGL -lGLU" >> Makefile.config || die
	if use glut; then
		echo "GLUTLIBS = -lglut" >> Makefile.config || die
	else
		echo "GLUTLIBS = " >> Makefile.config || die
	fi
	echo "XLIBS = -lXext -lXmu -lX11" >> Makefile.config || die
	echo "RANLIB = $(tc-getRANLIB)" >> Makefile.config || die
	echo 'COPTS = -c -O $(CFLAGS)' >> Makefile.config || die
	echo 'INCLUDES = $(TKINCLUDES) $(GLINCLUDES) $(XINCLUDES)' >> Makefile.config || die
}

src_compile() {
	# Workaround for bug #834870
	MAKEOPTS+=" -j1"

	if use tk; then
		emake togl
		if use ocamlopt; then
			emake toglopt
		fi
	fi

	emake lib
	if use ocamlopt; then
		emake libopt
	fi

	if use glut; then
		emake glut
		if use ocamlopt; then
			emake glutopt
		fi
	fi
}

src_install() {
	# Makefile do not use mkdir so the library is not installed
	# but copied as a 'stublibs' file.
	dodir /usr/$(get_libdir)/ocaml/stublibs

	# Same for lablglut's toplevel
	if use tk ; then
		dodir /usr/bin
	fi

	BINDIR="${ED}/usr/bin"
	BASE="${ED}/usr/$(get_libdir)/ocaml"
	emake BINDIR="${BINDIR}" INSTALLDIR="${BASE}/lablGL" DLLDIR="${BASE}/stublibs" install
	strip-lto-bytecode

	dodoc README CHANGES

	if use doc ; then
		mv Togl/examples{,.togl} || die
		dodoc -r Togl/examples.togl

		mv LablGlut/examples{,.glut} || die
		dodoc -r LablGlut/examples.glut
	fi
}
