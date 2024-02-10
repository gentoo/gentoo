# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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

src_compile() {
	exts=.cma
	use ocamlopt && exts+=' .cmx .cmxa'
	export pkgs
	emake TARGETS="${exts}"
}

src_test() {
	emake -j1 TARGETS="${exts}" test
}

src_install() {
	local archives=''
	use ocamlopt && archives='_build/lib/process.a'
	findlib_src_install TARGETS="${exts}" ARCHIVES="${archives}"
}
