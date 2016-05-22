# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit latex-package

DESCRIPTION="Reimplementation of the bibliographic facilities provided by LaTeX"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/biblatex https://github.com/plk/biblatex/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tds.tgz"

LICENSE="LPPL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="dev-texlive/texlive-bibtexextra
	dev-texlive/texlive-latexextra"
DEPEND="${RDEPEND}"

S=${WORKDIR}
TEXMF=/usr/share/texmf-site

src_install() {
	insinto "${TEXMF}"
	doins -r bibtex tex

	dodoc doc/latex/biblatex/{README,CHANGES}
	use doc && { pushd doc/ ; latex-package_src_doinstall doc ; popd ; }
	if use examples ; then
		docinto examples
		dodoc -r doc/latex/biblatex/examples
	fi
}
