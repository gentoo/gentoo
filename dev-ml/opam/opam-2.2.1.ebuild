# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME="opam"
inherit dune

DESCRIPTION="A source-based package manager for OCaml"
HOMEPAGE="http://opam.ocaml.org/"
SRC_URI="https://github.com/ocaml/opam/archive/${PV/_/-}.tar.gz -> opam-${PV}.tar.gz"
S="${WORKDIR}/opam-${PV/_/-}"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="+ocamlopt"
RESTRICT="test" #see bugs 838658

RDEPEND="
	dev-ml/0install:=[ocamlopt?]
	dev-ml/cmdliner:=[ocamlopt?]
	dev-ml/cudf:=[ocamlopt?]
	dev-ml/dose3:=[ocamlopt?]
	dev-ml/extlib:=[ocamlopt?]
	dev-ml/jsonm:=[ocamlopt?]
	dev-ml/ocaml-base64:=[ocamlopt?]
	dev-ml/ocamlgraph:=[ocamlopt?]
	dev-ml/ocaml-sha:=[ocamlopt?]
	dev-ml/opam-0install-cudf:=[ocamlopt?]
	dev-ml/opam-common:=[ocamlopt?]
	dev-ml/opam-file-format:=[ocamlopt?]
	dev-ml/re:=[ocamlopt?]
	dev-ml/spdx_licenses:=[ocamlopt?]
	dev-ml/stdlib-shims:=[ocamlopt?]
	dev-ml/swhid_core:=[ocamlopt?]
	dev-ml/uchar:=[ocamlopt?]
	dev-ml/uutf:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND="dev-ml/findlib"

src_configure() {
	:
}

src_compile() {
	dune-compile opam-solver opam-repository opam-state opam-client ${DUNE_PKG_NAME}
}

src_install() {
	dune_src_install
	mv "${ED}"/usr/share/doc/${PF}/${PN}/* \
		"${ED}"/usr/share/doc/${PF} || die
}
