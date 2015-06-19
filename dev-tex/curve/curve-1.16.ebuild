# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/curve/curve-1.16.ebuild,v 1.4 2012/03/06 14:24:40 ranger Exp $

EAPI=2

inherit latex-package

S=${WORKDIR}/${PN}

DESCRIPTION="LaTeX style for a CV (curriculum vitae) with flavour option"
SRC_URI="ftp://tug.ctan.org/pub/tex-archive/macros/latex/contrib/${PN}.zip -> ${P}.zip"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/curve/"
LICENSE="LPPL-1.2"
RDEPEND=">=dev-texlive/texlive-latexextra-2010"
DEPEND="${RDEPEND}
	app-arch/unzip"
IUSE="doc examples"

SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

TEXMF=/usr/share/texmf-site

src_install() {

	latex-package_src_doinstall styles

	dodoc README NEWS THANKS

	if use doc ; then
		latex-package_src_doinstall pdf
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}/example
		doins examples/*
	fi
}
