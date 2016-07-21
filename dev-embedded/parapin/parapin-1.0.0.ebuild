# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="A parallel port pin programming library"
HOMEPAGE="http://parapin.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
IUSE="doc"
KEYWORDS="x86 ~amd64"

SLOT="0"

DEPEND="doc? ( dev-tex/latex2html )"
RDEPEND=""

src_compile() {
	# Note 2.4 and 2.6 makefiles are identical for the targets used
	emake -f Makefile-2.4 CC=$(tc-getCC) || die
}

src_install() {
	dolib.a libparapin.a
	insopts -m0444;	insinto /usr/include; doins parapin.h

	dodoc README
	if use doc; then
		cd doc
		emake html
		cd parapin
		dohtml *.html *.css *.png

		cd ${S}
		docinto examples
		dodoc examples/*.c
	fi
}
