# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit findlib

DESCRIPTION="Library for binding to C libraries using pure OCaml"
HOMEPAGE="https://github.com/ocamllabs/ocaml-ctypes/"
SRC_URI="https://github.com/ocamllabs/ocaml-ctypes/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/ocaml-4.02:=
	>=dev-libs/libffi-3.3_rc0:=
	dev-ml/bigarray-compat:=
	dev-ml/integers:=
"
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit2 dev-ml/lwt )"
REQUIRED_USE="ocamlopt"

PATCHES=( "${FILESDIR}"/${PN}-0.20.0-shuffle.patch )

src_prepare() {
	sed -e 's/oUnit/ounit2/g' -i Makefile.tests || die
	default
}

src_compile() {
	emake -j1
}

src_test() {
	emake -j1 test
}

src_install() {
	findlib_src_install
	dodoc CHANGES.md README.md
}
