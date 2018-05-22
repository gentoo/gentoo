# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk(-)"

inherit prefix python-single-r1 toolchain-funcs

DESCRIPTION="Open-source graphical front end for computational chemistry programs"
HOMEPAGE="http://viewmol.sourceforge.net/"
SRC_URI="mirror://sourceforge/viewmol/${P}.src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	media-libs/libpng:0=
	media-libs/tiff:0
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/motif:0
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S="${WORKDIR}/${P}/source"

PATCHES=(
	"${FILESDIR}"/${PV}-remove-icc-check.patch
	"${FILESDIR}"/${PV}-change-default-paths.patch
)

src_prepare() {
	default

	eprefixify getrc.c
	sed "s:GENTOOLIBDIR:$(get_libdir):g" -i install getrc.c || die
	sed "s:GENTOODOCDIR:${PF}:g" -i install || die

	mkdir "$(uname -s)" || die
	cd "$(uname -s)" || die

	cat >> ".config.$(uname -s)" <<- EOF || die
		LIBTIFF = -L"${EPREFIX}/usr/$(get_libdir)"
		TIFFINCLUDE = "${EPREFIX}/usr/include"

		LIBPNG = -L"${EPREFIX}/usr/$(get_libdir)"
		PNGINCLUDE = "${EPREFIX}/usr/include"

		PYTHONVERSION = ${EPYTHON}
		PYTHONINCLUDE = $(python_get_CFLAGS)
		PYTHONLIB = $(python_get_LIBS)

		COMPILER = $(tc-getCC)
		CFLAGS = ${CFLAGS} -DLINUX
		LDFLAGS = ${LDFLAGS}
		SCANDIR=
		INCLUDE=\$(TIFFINCLUDE) -I\$(PNGINCLUDE) \$(PYTHONINCLUDE)
		LIBRARY=\$(LIBTIFF) \$(LIBPNG) \$(PYTHONLIB)
		LIBS=-L"${EPREFIX}/usr/$(get_libdir)" -ltiff -lpng -lz -lGLU -lGL -L"${EPREFIX}/usr/X11R6/lib" -lXm -lXmu -lXp -lXi -lXext -lXt -lX11 -lpthread -lutil -ldl -lm
	EOF

	cp .config.$(uname -s) makefile || die
	cat ../Makefile >> makefile || die
}

src_compile() {
	emake -C "$(uname -s)" viewmol_ tm_ bio_ readgamess_ readgauss_ readmopac_ readpdb_
	"${EPREFIX}"/bin/bash makeTranslations || die
}

src_install() {
	./install "${ED%/}"/usr || die

	# fix broken layout
	mv "${ED%/}"/usr/{usr/share,} || die
	rm -rf "${ED%/}"/usr/usr || die
	mv "${ED%/}"/usr/{$(get_libdir)/${PN}/locale,share} || die
	mv "${ED%/}"/usr/{$(get_libdir),libexec} || die
}
