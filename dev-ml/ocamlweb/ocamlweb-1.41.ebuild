# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="O'Caml literate programming tool"
HOMEPAGE="https://www.lri.fr/~filliatr/ocamlweb/"
SRC_URI="https://www.lri.fr/~filliatr/ftp/ocamlweb/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND=">=dev-lang/ocaml-4.08.0:=
	virtual/latex-base
	dev-texlive/texlive-latexextra"
BDEPEND="test? ( dev-tex/hevea )"

PATCHES=(
	"${FILESDIR}/${PN}-1.41-strip.patch"
	"${FILESDIR}/${PN}-1.41-ocaml-4.08.0.patch"
	)

QA_FLAGS_IGNORED=/usr/bin/ocamlweb

src_compile() {
	default
}

src_install() {
	emake UPDATETEX="" prefix="${D}/usr" MANDIR="${D}/usr/share/man" BASETEXDIR="${D}/${TEXMF}" install
	dodoc README CHANGES
}
