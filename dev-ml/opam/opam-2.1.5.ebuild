# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A source-based package manager for OCaml"
HOMEPAGE="http://opam.ocaml.org/"
SRC_URI="https://github.com/ocaml/opam/archive/${PV/_/-}.tar.gz -> opam-${PV}.tar.gz"
S="${WORKDIR}/opam-${PV/_/-}"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"
RESTRICT="test" #see bugs 838658

RDEPEND="
	dev-ml/cmdliner:=[ocamlopt?]
	dev-ml/cudf:=[ocamlopt?]
	dev-ml/dose3:=[ocamlopt?]
	dev-ml/extlib:=[ocamlopt?]
	~dev-ml/opam-client-${PV}:=[ocamlopt?]
	dev-ml/opam-file-format:=[ocamlopt?]
	dev-ml/re:=[ocamlopt?]
	sys-apps/bubblewrap"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	cat <<- EOF >> "${S}/dune"
		(env
		 (dev
		  (flags (:standard -warn-error -3-9-33)))
		 (release
		  (flags (:standard -warn-error -3-9-33))))
	EOF
}

src_compile() {
	dune-compile ${PN}
}
