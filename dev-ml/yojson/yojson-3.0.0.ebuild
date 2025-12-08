# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="JSON parsing and pretty-printing library for OCaml"
HOMEPAGE="https://github.com/ocaml-community/yojson/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ocaml-community/${PN}"
else
	SRC_URI="https://github.com/ocaml-community/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="BSD"
SLOT="0/${PV}"
IUSE="examples +ocamlopt test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-ml/alcotest )
"

src_prepare() {
	default

	# let's not build this
	rm bench/dune yojson-bench.opam || die
}

src_compile() {
	dune-compile "${PN}"
}

src_test() {
	dune-test "${PN}"
}

src_install() {
	dune_src_install

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
