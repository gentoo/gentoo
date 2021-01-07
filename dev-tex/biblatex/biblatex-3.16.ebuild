# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="Reimplementation of the bibliographic facilities provided by LaTeX"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/biblatex https://github.com/plk/biblatex/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tds.tgz"

LICENSE="LPPL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+biber doc examples"

DEPEND="dev-texlive/texlive-bibtexextra
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-plaingeneric"
RDEPEND="${DEPEND}"
PDEPEND="biber? ( ~dev-tex/biber-2.16 )"

S="${WORKDIR}"
TEXMF=/usr/share/texmf-site

src_install() {
	insinto "${TEXMF}"
	doins -r bibtex tex

	dodoc doc/latex/biblatex/{README,CHANGES.md}
	if use doc ; then
		pushd doc || die
		latex-package_src_doinstall doc
		popd || die
	fi

	if use examples ; then
		dodoc -r doc/latex/biblatex/examples
	fi
}
