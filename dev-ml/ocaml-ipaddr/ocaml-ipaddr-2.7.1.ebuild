# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="OCaml library for manipulation of IP (and MAC) address representations"
HOMEPAGE="https://github.com/mirage/ocaml-ipaddr"
SRC_URI="https://github.com/mirage/ocaml-ipaddr/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt test"

RDEPEND="dev-ml/sexplib:=
	dev-ml/ppx_sexp_conv:=
	dev-lang/ocaml:=[ocamlopt?]
"
DEPEND="${RDEPEND}
	dev-ml/ocamlbuild
	dev-ml/topkg
	dev-ml/findlib
	test? ( dev-ml/ounit )
"

src_compile() {
	ocaml pkg/pkg.ml build \
		--tests $(usex test "true" "false") || die
}

src_test() {
	ocaml pkg/pkg.ml test || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		ipaddr.install || die
	dodoc CHANGES.md README.md
}
