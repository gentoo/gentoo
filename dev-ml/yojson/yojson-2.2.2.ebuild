# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="JSON parsing and pretty-printing library for OCaml"
HOMEPAGE="https://github.com/ocaml-community/yojson"
SRC_URI="https://github.com/ocaml-community/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="examples +ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/sedlex:=[ocamlopt?]
	!!<dev-ml/seq-0.3
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? ( dev-ml/alcotest )
"

PATCHES=( "${FILESDIR}/${PN}-2.1.1-dune-seq.patch" )

src_prepare() {
	default
	# let's not build this
	rm bench/dune yojson-bench.opam || die
}

src_install() {
	dune_src_install

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
