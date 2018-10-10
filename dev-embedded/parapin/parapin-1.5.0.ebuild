# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="A parallel port pin programming library"
HOMEPAGE="http://parapin.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="LGPL-2.1"
IUSE="doc"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DEPEND="doc? ( dev-tex/latex2html )"

src_compile() {
	# Note 2.4 and 2.6 makefiles are identical for the targets used
	emake -f Makefile-2.4 CC=$(tc-getCC)
	use doc && emake -C doc html
}

src_install() {
	dolib.a libparapin.a
	insopts -m0444;	insinto /usr/include; doins parapin.h

	dodoc README
	if use doc; then
		cd "${S}"/doc/${PN}
		docinto html
		dodoc *.html *.css *.png

		cd "${S}"/examples
		docinto examples
		dodoc *.c
	fi
}
