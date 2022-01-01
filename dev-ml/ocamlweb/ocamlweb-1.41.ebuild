# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="O'Caml literate programming tool"
HOMEPAGE="https://www.lri.fr/~filliatr/ocamlweb/"
SRC_URI="https://www.lri.fr/~filliatr/ftp/ocamlweb/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"

DEPEND=">=dev-lang/ocaml-4.08.0:=
	virtual/latex-base
	dev-texlive/texlive-latexextra
	"

PATCHES=(
	"${FILESDIR}/${PN}-1.41-strip.patch"
	"${FILESDIR}/${PN}-1.41-ocaml-4.08.0.patch"
	)

src_compile() {
	emake
}

src_install() {
	emake UPDATETEX="" prefix="${D}/usr" MANDIR="${D}/usr/share/man" BASETEXDIR="${D}/${TEXMF}" install
	dodoc README CHANGES
}
