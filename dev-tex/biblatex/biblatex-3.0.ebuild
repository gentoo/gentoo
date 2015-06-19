# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/biblatex/biblatex-3.0.ebuild,v 1.2 2015/06/01 19:47:31 mrueg Exp $

EAPI=5

inherit latex-package

DESCRIPTION="Reimplementation of the bibliographic facilities provided by LaTeX"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/biblatex https://github.com/plk/biblatex/"
SRC_URI="https://github.com/plk/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LPPL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="dev-texlive/texlive-bibtexextra
	dev-texlive/texlive-latexextra"
DEPEND="${RDEPEND}"

TEXMF=/usr/share/texmf-site

src_install() {
	insinto "${TEXMF}"
	doins -r bibtex tex

	dodoc doc/latex/biblatex/{README,RELEASE}
	use doc && { pushd doc/ ; latex-package_src_doinstall doc ; popd ; }
	if use examples ; then
		docinto examples
		dodoc -r doc/latex/biblatex/examples
	fi
}
