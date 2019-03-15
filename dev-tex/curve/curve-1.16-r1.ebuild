# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="LaTeX style for a CV (curriculum vitae) with flavour option"
HOMEPAGE="https://ctan.org/tex-archive/macros/latex/contrib/curve/"
SRC_URI="http://mirrors.ctan.org/macros/latex/contrib/${PN}.zip -> ${P}.zip"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="doc examples"

RDEPEND=">=dev-texlive/texlive-latexextra-2010"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${PN}

TEXMF=/usr/share/texmf-site

src_install() {
	dodoc README NEWS THANKS

	latex-package_src_doinstall styles

	if use doc ; then
		latex-package_src_doinstall pdf
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}/example
		doins examples/*
	fi
}
