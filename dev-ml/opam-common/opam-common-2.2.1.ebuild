# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Core libraries for opam"
HOMEPAGE="https://opam.ocaml.org/ https://github.com/ocaml/opam"
SRC_URI="https://github.com/ocaml/opam/archive/${PV/_/-}.tar.gz -> opam-${PV}.tar.gz"
S="${WORKDIR}/opam-${PV}"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"
RESTRICT="test" #sandbox not working

RDEPEND="
	dev-ml/jsonm:=[ocamlopt?]
	dev-ml/ocamlgraph:=[ocamlopt?]
	dev-ml/ocaml-sha:=[ocamlopt?]
	dev-ml/opam-file-format:=[ocamlopt?]
	dev-ml/re:=[ocamlopt?]
	dev-ml/stdlib-shims:=[ocamlopt?]
	dev-ml/swhid_core:=[ocamlopt?]
	dev-ml/uchar:=[ocamlopt?]
	dev-ml/uutf:=[ocamlopt?]
	!<dev-ml/opam-2.2
"
DEPEND="${RDEPEND}"
BDEPEND="dev-ml/findlib"

src_configure() {
	:
}

src_compile() {
	dune-compile opam-core opam-format
}

src_install() {
	dune-install opam-core opam-format
}
