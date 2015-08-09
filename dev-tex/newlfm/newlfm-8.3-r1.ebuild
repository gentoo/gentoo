# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit latex-package

DESCRIPTION="Extensive LaTeX class for writing letters"
HOMEPAGE="http://www.ctan.org/tex-archive/help/Catalogue/entries/newlfm.html"
# Downloaded from:
# ftp://ftp.dante.de/tex-archive/macros/latex/contrib/newlfm.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="dev-texlive/texlive-latexextra"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}"

src_compile() {
	latex newlfm.ins || die
}

src_install() {
	insinto /usr/share/texmf/tex/latex/newlfm
	doins *.sty *.cls letrinfo.tex lvb.* palm.* wine.*

	dosym palm.eps /usr/share/texmf/tex/latex/newlfm/palmb.eps
	dosym palm.pdf /usr/share/texmf/tex/latex/newlfm/palmb.pdf

	insinto /usr/share/doc/${PF}/tests
	doins test* extracd.tex # letrx.tex

	dodoc manual.pdf README # README.uploads
}
