# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="A free implementation of the OpenGL Character Renderer (GLC)"
HOMEPAGE="http://quesoglc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-free.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="doc examples static-libs"

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/fontconfig
	media-libs/freetype:2
	dev-libs/fribidi"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_prepare() {
	rm -rf src/fribidi
}

src_configure() {
	# Uses its own copy of media-libs/glew with GLEW_MX
	econf \
		--disable-executables \
		--with-fribidi \
		--without-glew \
		$(use_enable static-libs static)
}

src_compile() {
	emake
	if use doc ; then
		cd docs
		doxygen -u Doxyfile && doxygen || die
	fi
}

src_install() {
	default
	if use doc ; then
		dohtml docs/html/*
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.c
	fi
	prune_libtool_files
}
