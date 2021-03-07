# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="O'Caml Graph library"
HOMEPAGE="http://ocamlgraph.lri.fr/index.en.html"
SRC_URI="https://github.com/backtracking/${PN}/releases/download/${PV}/${P}.tbz"
LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
RDEPEND="
	gtk? ( dev-ml/lablgtk:2=[ocamlopt?,gnomecanvas] )
	dev-ml/stdlib-shims:=[ocamlopt?]
	dev-ml/graphics:=[ocamlopt?]"
DEPEND="${RDEPEND}"
IUSE="gtk +ocamlopt"

src_compile() {
	if ! use gtk; then
		dune build --only-packages ocamlgraph @install || die
	else
		dune build @install || die
	fi
}
