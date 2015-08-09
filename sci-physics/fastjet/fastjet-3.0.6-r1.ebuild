# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

FORTRAN_NEEDED=plugins
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils fortran-2 flag-o-matic

DESCRIPTION="Fast implementation of several recombination jet algorithms"
HOMEPAGE="http://www.fastjet.fr/"
SRC_URI="${HOMEPAGE}/repo/${P}.tar.gz"

LICENSE="GPL-2 QPL"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cgal doc examples +plugins static-libs"

RDEPEND="cgal? ( sci-mathematics/cgal )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
	plugins? ( sci-physics/siscone:0= )"

PATCHES=( "${FILESDIR}"/${P}-system-siscone.patch )

src_configure() {
	use cgal && \
		has_version sci-mathematics/cgal[gmp] && append-ldflags -lgmp
	local myeconfargs=(
		$(use_enable cgal)
		$(use_enable plugins allplugins)
		$(use_enable plugins allcxxplugins)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	if use doc; then
		doxygen Doxyfile || die
	fi
}

src_install() {
	autotools-utils_src_install
	use doc && dohtml -r html/*
	if use examples; then
		insinto /usr/share/doc/${PF}
		find example \
			-name Makefile -or Makefile.in -or Makefile.am -delete
		doins -r example/*
	fi
}
