# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="JSON parsing and pretty-printing library for OCaml"
HOMEPAGE="https://github.com/ocaml-community/yojson"
SRC_URI="https://github.com/ocaml-community/yojson/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="examples +ocamlopt"

RDEPEND=">=dev-lang/ocaml-4.02.3:=[ocamlopt]
	dev-ml/easy-format:=[ocamlopt]
	>=dev-ml/biniou-1.2:=[ocamlopt]
"
DEPEND="${RDEPEND}
	>=dev-ml/cppo-1.6.1
"

src_install() {
	dune_src_install

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
