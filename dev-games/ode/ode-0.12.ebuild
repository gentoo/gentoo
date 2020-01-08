# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="Open Dynamics Engine SDK"
HOMEPAGE="http://ode.org/"
SRC_URI="mirror://sourceforge/opende/${P}.tar.bz2"

LICENSE="|| ( LGPL-2.1 BSD )"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debug doc double-precision examples gyroscopic static-libs"

RDEPEND="examples? (
		virtual/opengl
	)"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	sed -i \
		-e "s:\$.*/drawstuff/textures:/usr/share/doc/${PF}/examples:" \
		drawstuff/src/Makefile.in \
		ode/demo/Makefile.in || die
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
	DOCS="CHANGELOG.txt README.txt" \
		default
	prune_libtool_files
	if use doc ; then
		dohtml docs/*
	fi
	if use examples; then
		cd ode/demo
		exeinto /usr/share/doc/${PF}/examples
		local f
		for f in *.c* ; do
			doexe .libs/${f%.*}
		done
		cd ../..
		doexe drawstuff/dstest/dstest
		insinto /usr/share/doc/${PF}/examples
		doins ode/demo/*.{c,cpp,h} \
			drawstuff/textures/*.ppm \
			drawstuff/dstest/dstest.cpp \
			drawstuff/src/{drawstuff.cpp,internal.h,x11.cpp}
	fi
}
