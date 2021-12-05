# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="Easy process control for OCaml"
HOMEPAGE="https://github.com/dsheets/ocaml-process"
SRC_URI="https://github.com/dsheets/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-ml/ocamlbuild
	test? ( dev-ml/alcotest )
"

src_install() {
	findlib_src_install
}

src_test() {
	emake -j1 test
}
