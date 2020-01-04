# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

IUSE="doc +ocamlopt"

DESCRIPTION="A bibtex to HTML converter"
SRC_URI="https://www.lri.fr/~filliatr/ftp/bibtex2html/${P}.tar.gz"
HOMEPAGE="https://www.lri.fr/~filliatr/bibtex2html/"

SLOT="0"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
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

PATCHES=( "${FILESDIR}/${PN}-1.88-destdir.patch" )

src_prepare() {
	default
	# Avoid pre-stripped files
	sed -i -e "s/strip/true/" Makefile.in || die
	# For make install
	use ocamlopt || sed -i 's/= opt /= noopt /' Makefile.in || die
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
		dodoc -r manual.{pdf,html}
	fi
}
