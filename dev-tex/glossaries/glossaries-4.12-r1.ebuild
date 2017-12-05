# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit latex-package

DESCRIPTION="Create glossaries and lists of acronyms"
HOMEPAGE="http://www.ctan.org/pkg/glossaries/"
SRC_URI="https://dev.gentoo.org/~radhermit/dist/${P}.zip"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples"

RDEPEND="dev-lang/perl
	dev-texlive/texlive-latexrecommended
	>=dev-texlive/texlive-latexextra-2012
	|| ( dev-texlive/texlive-plaingeneric >=dev-texlive/texlive-genericextra-2014 )"
DEPEND="${RDEPEND}
	app-arch/unzip"

TEXMF="/usr/share/texmf-site"
S=${WORKDIR}/${PN}

src_install() {
	latex-package_src_doinstall styles

	dobin makeglossaries

	dodoc CHANGES README
	if use doc ; then
		latex-package_src_doinstall pdf
	fi
	if use examples ; then
		docinto examples
		dodoc samples/*.tex
	fi
}
