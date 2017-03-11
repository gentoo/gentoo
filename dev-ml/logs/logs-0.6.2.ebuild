# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit findlib

DESCRIPTION="Logging infrastructure for OCaml"
HOMEPAGE="http://erratique.ch/software/logs https://github.com/dbuenzli/logs"
SRC_URI="http://erratique.ch/software/logs/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="javascript +fmt cli +lwt test"

RDEPEND="
	dev-ml/result:=[ocamlopt]
	dev-lang/ocaml:=[ocamlopt]
	javascript? ( dev-ml/js_of_ocaml:= )
	fmt? ( dev-ml/fmt:= )
	cli? ( dev-ml/cmdliner:=[ocamlopt] )
	lwt? ( dev-ml/lwt:= )
"
DEPEND="${RDEPEND}
	dev-ml/opam
	dev-ml/topkg
	dev-ml/ocamlbuild
	dev-ml/findlib
	test? ( dev-ml/mtime )
"

src_compile() {
	ocaml pkg/pkg.ml build \
		--with-js_of_ocaml $(usex javascript true false) \
		--with-fmt $(usex fmt true false) \
		--with-cmdliner $(usex cli true false) \
		--with-lwt $(usex fmt true false) \
		--tests $(usex test true false) \
		|| die
}

src_test() {
	ocaml pkg/pkg.ml test || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
	dodoc CHANGES.md README.md
}
