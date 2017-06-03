# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib

DESCRIPTION="RFC3986 URI parsing library for OCaml"
HOMEPAGE="https://github.com/mirage/ocaml-uri https://mirage.io"
SRC_URI="https://github.com/mirage/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-ml/ocaml-re:=
	dev-ml/sexplib:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/stringext:=
	dev-ml/type-conv:=
	dev-lang/ocaml:=
"
DEPEND="${RDEPEND}
	test? ( >=dev-ml/ounit-1.0.2 )
	dev-ml/jbuilder
	dev-ml/opam
"

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		uri.install || die
}
