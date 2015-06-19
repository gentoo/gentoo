# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/dot2texi/dot2texi-3.0.ebuild,v 1.20 2012/04/22 18:30:13 grobian Exp $

inherit latex-package

DESCRIPTION="Create graphs within LaTeX using the dot2tex tool"
HOMEPAGE="http://www.ctan.org/tex-archive/help/Catalogue/entries/dot2texi.html"
# Taken from http://theory.uwinnipeg.ca/scripts/CTAN/macros/latex/contrib/dot2texi.zip
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="pgf pstricks examples"

DEPEND="app-arch/unzip"
RDEPEND="pstricks? ( dev-texlive/texlive-pstricks )
	pgf? ( dev-tex/pgf )
	dev-texlive/texlive-latexrecommended
	dev-texlive/texlive-latexextra
	>=dev-tex/dot2tex-2.7.0"

S="${WORKDIR}/${PN}"

TEXMF="/usr/share/texmf-site"

src_install() {
	latex-package_src_doinstall sty pdf

	dodoc README
	dodoc ${PN}.tex

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins examples/*
	fi
}
