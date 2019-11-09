# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="Create graphs within LaTeX using the dot2tex tool"
HOMEPAGE="https://www.ctan.org/pkg/dot2texi"
# Taken from http://theory.uwinnipeg.ca/scripts/CTAN/macros/latex/contrib/dot2texi.zip
SRC_URI="mirror://gentoo/${P}.zip"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"

LICENSE="GPL-2"
SLOT="0"
IUSE="pgf pstricks examples"

DEPEND="app-arch/unzip"
RDEPEND="pstricks? ( dev-texlive/texlive-pstricks )
	pgf? ( dev-tex/pgf )
	dev-texlive/texlive-latexrecommended
	dev-texlive/texlive-latexextra
	>=dev-tex/dot2tex-2.7.0"

TEXMF="/usr/share/texmf-site"

S="${WORKDIR}/${PN}"

src_install() {
	latex-package_src_doinstall sty pdf

	dodoc README
	dodoc ${PN}.tex

	if use examples; then
		docinto examples
		dodoc examples/*
	fi
}
