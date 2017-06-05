# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
	dev-ml/jbuilder
	dev-ml/opam
	dev-ml/findlib
	test? ( dev-ml/ounit )
"

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		ipaddr.install || die
	dodoc CHANGES.md README.md
}
