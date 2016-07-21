# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="Celestial Mechanics and Astronomical Calculation Library"
HOMEPAGE="http://libnova.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_prepare() {
	sed -i -e '/CFLAGS=-Wall/d' configure.in || die
	autotools-utils_src_prepare
}

src_compile() {
	autotools-utils_src_compile
	use doc && autotools-utils_src_compile -C doc doc
}

src_install() {
	autotools-utils_src_install
	use doc && dohtml doc/html/*
	if use examples; then
		make clean
		rm examples/Makefile*
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
