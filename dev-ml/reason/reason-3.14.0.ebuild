# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Simple, fast & type safe language that leverages JavaScript and OCaml"
HOMEPAGE="https://reasonml.github.io/
	https://github.com/reasonml/reason/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/reasonml/${PN}.git"
else
	SRC_URI="https://github.com/reasonml/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0/${PV}"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/dune-build-info:=[ocamlopt?]
	dev-ml/fix:=[ocamlopt?]
	dev-ml/menhir:=[ocamlopt?]
	dev-ml/merlin-extend:=[ocamlopt?]
	dev-ml/ppx_derivers:=[ocamlopt?]
	dev-ml/ppxlib:=[ocamlopt?]
	dev-ml/utop:=[ocamlopt?]
"
DEPEND="
	${RDEPEND}
"

src_install() {
	dune-install reason rtop

	dodoc ./*.md ./docs/*.md
}
