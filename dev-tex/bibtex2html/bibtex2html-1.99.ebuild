# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A bibtex to HTML converter"
HOMEPAGE="https://www.lri.fr/~filliatr/bibtex2html/"
SRC_URI="https://www.lri.fr/~filliatr/ftp/bibtex2html/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

IUSE="doc +ocamlopt"

# With use doc we need a latex compiler to generate manual.pdf
# hevea is used for manual.html
# manual.tex needs fullpage.sty
DEPEND=">=dev-lang/ocaml-3.10:=[ocamlopt?]
	doc? ( virtual/latex-base
		dev-texlive/texlive-latexextra
		dev-tex/hevea )"
# We need tex-base for bibtex but also some bibtex styles, so we use latex-base
RDEPEND="virtual/latex-base"

PATCHES="${FILESDIR}/${P}-destdir.patch"

src_prepare() {
	default
	# Avoid pre-stripped files
	sed -i -e "s/strip/true/" Makefile.in
	# For make install
	use ocamlopt || sed -i 's/= opt /= noopt /' Makefile.in
}

src_compile() {
	local VARTEXFONTS="${T}/fonts"
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
	default
	use doc && dodoc manual.pdf
}
