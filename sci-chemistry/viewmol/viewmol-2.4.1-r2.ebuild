# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

PYTHON_DEPEND="2"
PYTHON_USE_WITH="tk"

inherit eutils multilib prefix python toolchain-funcs

DESCRIPTION="Open-source graphical front end for computational chemistry programs"
HOMEPAGE="http://viewmol.sourceforge.net/"
SRC_URI="mirror://sourceforge/viewmol/${P}.src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libpng
	media-libs/tiff
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXt
	>=x11-libs/motif-2.3:0"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/xproto"

S="${WORKDIR}/${P}/source"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-remove-icc-check.patch \
		"${FILESDIR}"/${PV}-change-default-paths.patch

	eprefixify getrc.c
	sed "s:GENTOOLIBDIR:$(get_libdir):g" \
		-i install getrc.c || die
	sed "s:GENTOODOCDIR:${PF}:g" -i install || die

	LINKFORSHARED=$($(PYTHON) -c "import distutils.sysconfig; print distutils.sysconfig.get_config_var('LINKFORSHARED')")

	mkdir $(uname -s) && cd $(uname -s)

	cat >> .config.$(uname -s) <<- EOF
	LIBTIFF = -L"${EPREFIX}/usr/$(get_libdir)"
	TIFFINCLUDE = "${EPREFIX}/usr/include"
	LIBPNG = -L"${EPREFIX}/usr/$(get_libdir)"
	PNGINCLUDE = "${EPREFIX}/usr/include"
	PYTHONVERSION = $(PYTHON)
	PYTHONINCLUDE = "${EPREFIX}/$(python_get_includedir)"
	PYTHONLIB = "${EPREFIX}/usr/$(get_libdir)"
	COMPILER = $(tc-getCC)
	CFLAGS = ${CFLAGS} -DLINUX
	LDFLAGS = ${LDFLAGS} ${LINKFORSHARED}
	SCANDIR=
	INCLUDE=\$(TIFFINCLUDE) -I\$(PNGINCLUDE) -I\$(PYTHONINCLUDE)
	LIBRARY=\$(LIBTIFF) \$(LIBPNG) -L\$(LIBPYTHON)
	LIBS=-L"${EPREFIX}/usr/$(get_libdir)" $(python_get_library -l) -ltiff -lpng -lz -lGLU -lGL -L"${EPREFIX}/usr/X11R6/lib" -lXm -lXmu -lXp -lXi -lXext -lXt -lX11 -lpthread -lutil -ldl -lm
	EOF

	cp .config.$(uname -s) makefile
	cat ../Makefile >> makefile
}

src_compile() {
	pushd $(uname -s)
	emake viewmol_ tm_ bio_ readgamess_ readgauss_ readmopac_ readpdb_ || die
	popd
	"${EPREFIX}"/bin/bash makeTranslations || die
}

src_install() {
	./install "${ED}"/usr || die
	mv "${ED}"/usr/{usr/share,} || die
	rm -rf "${ED}"/usr/usr
}
