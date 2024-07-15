# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="opam solver"
HOMEPAGE="https://opam.ocaml.org/ https://github.com/ocaml/opam"
SRC_URI="https://github.com/ocaml/opam/archive/${PV/_/-}.tar.gz -> opam-${PV}.tar.gz"
S="${WORKDIR}/opam-${PV/_/-}"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt test"
RESTRICT="test" # sandbox not working

RDEPEND="
	~dev-ml/opam-format-${PV}:=[ocamlopt?]
	dev-ml/opam-file-format:=[ocamlopt?]
	dev-ml/re:=[ocamlopt?]
	dev-ml/mccs:=[ocamlopt?]
	dev-ml/dose3:=[ocamlopt?]
	dev-ml/cudf:=[ocamlopt?]
"
DEPEND="${RDEPEND}
	test? ( dev-ml/opam-client )"

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
