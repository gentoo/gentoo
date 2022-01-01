# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit multilib eutils toolchain-funcs

DESCRIPTION="Objective CAML interface for OpenGL"
HOMEPAGE="http://wwwfun.kurims.kyoto-u.ac.jp/soft/olabl/lablgl.html"
LICENSE="BSD"

SRC_URI="http://wwwfun.kurims.kyoto-u.ac.jp/soft/olabl/dist/${P}.tar.gz"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc glut +ocamlopt tk"

RDEPEND="
	>=dev-lang/ocaml-3.10.2:=[ocamlopt?]
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libX11
	virtual/opengl
	virtual/glu
	dev-ml/camlp4:=
	glut? ( media-libs/freeglut )
	tk? (
		>=dev-lang/tcl-8.3:0=
		>=dev-lang/tk-8.3:0=
		dev-ml/labltk:=
	)
	"
DEPEND="${RDEPEND}"

src_configure() {
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
	dodir /usr/bin

	BINDIR="${ED}/usr/bin"
	BASE="${ED}/usr/$(get_libdir)/ocaml"
	emake BINDIR="${BINDIR}" INSTALLDIR="${BASE}/lablGL" DLLDIR="${BASE}/stublibs" install

	dodoc README CHANGES

	if use doc ; then
		mv Togl/examples{,.togl}
		dodoc -r Togl/examples.togl

		mv LablGlut/examples{,.glut}
		dodoc -r LablGlut/examples.glut
	fi
}
