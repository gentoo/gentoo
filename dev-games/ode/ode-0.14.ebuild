# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="Open Dynamics Engine SDK"
HOMEPAGE="http://ode.org/"
SRC_URI="https://bitbucket.org/odedevs/ode/downloads/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1+ BSD )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug doc double-precision examples gyroscopic static-libs"

RDEPEND="examples? (
	virtual/glu
	virtual/opengl )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

MY_EXAMPLES_DIR=/usr/share/doc/${PF}/examples

src_prepare() {
	sed -i \
		-e "s:\$.*/drawstuff/textures:${MY_EXAMPLES_DIR}:" \
		drawstuff/src/Makefile.am \
		ode/demo/Makefile.am || die
	eautoreconf
}

src_configure() {
	# use bash (bug #335760)
	CONFIG_SHELL=/bin/bash \
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable debug asserts) \
		$(use_enable double-precision) \
		$(use_enable examples demos) \
		$(use_enable gyroscopic) \
		$(use_with examples drawstuff X11)
}

src_compile() {
	emake
	if use doc ; then
		cd ode/doc
		doxygen Doxyfile || die
	fi
}

src_install() {
	DOCS="CHANGELOG.txt README.md" \
		default
	prune_libtool_files
	if use doc ; then
		dohtml docs/*
	fi
	if use examples; then
		docompress -x "${MY_EXAMPLES_DIR}"
		insinto "${MY_EXAMPLES_DIR}"
		exeinto "${MY_EXAMPLES_DIR}"
		doexe drawstuff/dstest/dstest
		doins ode/demo/*.{c,cpp,h} \
			drawstuff/textures/*.ppm \
			drawstuff/dstest/dstest.cpp \
			drawstuff/src/{drawstuff.cpp,internal.h,x11.cpp}
		cd ode/demo
		local f
		for f in *.c* ; do
			doexe .libs/${f%.*}
		done
	fi
}
