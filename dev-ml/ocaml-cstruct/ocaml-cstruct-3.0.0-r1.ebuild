# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib

DESCRIPTION="Map OCaml arrays onto C-like structs"
HOMEPAGE="https://github.com/mirage/ocaml-cstruct https://mirage.io"
SRC_URI="https://github.com/mirage/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="async +lwt +ppx test"

RDEPEND="
	async? ( dev-ml/async:= )
	lwt? ( dev-ml/lwt:= )
	ppx? (
		dev-ml/ppx_tools:=
		dev-ml/ocaml-migrate-parsetree:=
		dev-ml/ppx_tools_versioned:=
	)
	>=dev-lang/ocaml-4.01:=
	dev-ml/ocplib-endian:=
	dev-ml/sexplib:=
	dev-ml/type-conv:=
"
DEPEND="
	dev-ml/jbuilder
	dev-ml/opam
	test? ( dev-ml/ounit )
	${RDEPEND}
"

oinstall() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${1}.install || die
}

src_install() {
	oinstall cstruct
	oinstall cstruct-unix
	use lwt && oinstall cstruct-lwt
	use async && oinstall cstruct-async
	use ppx && oinstall ppx_cstruct
}
