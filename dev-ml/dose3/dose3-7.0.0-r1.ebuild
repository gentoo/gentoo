# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Library to perform analysis on package repositories"
HOMEPAGE="http://www.mancoosi.org/software/ https://gforge.inria.fr/projects/dose"
SRC_URI="https://gitlab.com/irill/${PN}/-/archive/${PV}/${P}.tar.bz2"
S="${WORKDIR}/${PN}-$(ver_cut 1-3)"

LICENSE="LGPL-3+" # with OCaml linking exception
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

BDEPEND="
	dev-ml/findlib
	dev-ml/ocamlbuild
"
# NOTE: dependencies on RPM, camlbz2, ZIP are unnecessary,
# because those are only used by dose3-extra
RDEPEND="
	dev-ml/ocaml-base64:=[ocamlopt?]
	dev-ml/cudf:=[ocamlopt?]
	>=dev-ml/extlib-1.7.8:=[ocamlopt?]
	dev-ml/ocamlgraph:=[ocamlopt?]
	dev-ml/re:=[ocamlopt?]
	dev-ml/parmap:=[ocamlopt?]
	dev-ml/ocaml-expat:=[ocamlopt?]
	dev-ml/xml-light:=[ocamlopt?]
"
DEPEND="${RDEPEND}"

# missing test data
RESTRICT="test"

src_compile() {
	dune-compile ${PN}
}
