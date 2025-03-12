# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit latex-package

DESCRIPTION="Reimplementation of the bibliographic facilities provided by LaTeX"
HOMEPAGE="https://www.ctan.org/tex-archive/macros/latex/contrib/biblatex https://github.com/plk/biblatex/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tds.tgz"

S="${WORKDIR}"

LICENSE="LPPL-1.3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

IUSE="+biber doc examples"

DEPEND="
	dev-texlive/texlive-bibtexextra
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-plaingeneric
"
RDEPEND="${DEPEND}"
# biblatex and biber must always have compatible versions
PDEPEND="biber? ( ~dev-tex/biber-2.$(ver_cut 2) )"
BDEPEND="
	doc? (
		virtual/latex-base
	)
"

TEXMF=/usr/share/texmf-site

src_install() {
	insinto "${TEXMF}"
	doins -r bibtex tex

	dodoc doc/latex/biblatex/{README,CHANGES.md}
	if use doc; then
		pushd doc/latex/biblatex >/dev/null || die
		LATEX_ENGINE=lualatex latex-package_src_doinstall doc
		popd >/dev/null || die
	fi

	if use examples ; then
		dodoc -r doc/latex/biblatex/examples
	fi
}
