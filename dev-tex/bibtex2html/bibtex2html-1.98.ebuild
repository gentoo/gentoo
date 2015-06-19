# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/bibtex2html/bibtex2html-1.98.ebuild,v 1.3 2015/02/21 12:14:18 ago Exp $

EAPI=5

inherit eutils

IUSE="doc +ocamlopt"

DESCRIPTION="A bibtex to HTML converter"
SRC_URI="http://www.lri.fr/~filliatr/ftp/bibtex2html/${P}.tar.gz"
HOMEPAGE="http://www.lri.fr/~filliatr/bibtex2html/"

SLOT="0"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~ppc64 ~x86"
RESTRICT="test"

# With use doc we need a latex compiler to generate manual.pdf
# hevea is used for manual.html
# manual.tex needs fullpage.sty
DEPEND=">=dev-lang/ocaml-3.10:=[ocamlopt?]
	doc? ( virtual/latex-base
		dev-texlive/texlive-latexextra
		dev-tex/hevea )"
# We need tex-base for bibtex but also some bibtex styles, so we use latex-base
RDEPEND="virtual/latex-base"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.88-destdir.patch"
	# Avoid pre-stripped files
	sed -i -e "s/strip/true/" Makefile.in
	# For make install
	use ocamlopt || sed -i 's/= opt /= noopt /' Makefile.in
}

src_compile() {
	export VARTEXFONTS="${T}/fonts"
	if use ocamlopt ; then
		emake opt
	else
		emake byte
	fi
	if use doc; then
		emake doc
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README CHANGES
	if use doc; then
		dodoc manual.pdf
		dohtml manual.html
	fi
}
