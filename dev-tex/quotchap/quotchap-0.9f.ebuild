# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit latex-package

S=${WORKDIR}/quotchap

DESCRIPTION="LaTeX package used to add quotes to chapters"
# Taken from http://theory.uwinnipeg.ca/scripts/CTAN/macros/latex/contrib/quotchap.zip
SRC_URI="mirror://gentoo/${P}.zip"
HOMEPAGE="ftp://ftp.dante.de/tex-archive/help/Catalogue/entries/quotchap.html"
LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_install () {
	export VARTEXFONTS="${T}/fonts"
	latex-package_src_doinstall all
	cd "${S}"
	dodoc 00readme.txt document.pdf document.tex
}
