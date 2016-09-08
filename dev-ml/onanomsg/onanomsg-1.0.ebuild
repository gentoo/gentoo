# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib

DESCRIPTION="nanomsg bindings for OCaml"
HOMEPAGE="https://github.com/rgrinberg/onanomsg"
SRC_URI="https://github.com/rgrinberg/onanomsg/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+lwt +ocamlopt test"

RDEPEND="
	dev-libs/nanomsg:=
	dev-lang/ocaml:=[ocamlopt?]
	dev-ml/ocaml-ctypes:=
	dev-ml/ocaml-ipaddr:=[ocamlopt?]
	dev-ml/ppx_deriving:=[ocamlopt?]
	dev-ml/ocaml-containers:=[ocamlopt?]
	lwt? ( dev-ml/lwt:=[ocamlopt?] )
"
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit )
"

src_compile() {
	ocaml pkg/build.ml \
		native=$(usex ocamlopt true false) \
		native-dynlink=$(usex ocamlopt true false) \
		lwt=$(usex lwt true false) \
		ounit=$(usex test true false) \
		|| die
}

src_install() {
	opam-installer \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		|| die
	dodoc CHANGES README.md
}
