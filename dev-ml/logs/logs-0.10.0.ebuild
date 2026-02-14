# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit findlib

DESCRIPTION="Logging infrastructure for OCaml"
HOMEPAGE="https://erratique.ch/software/logs https://github.com/dbuenzli/logs"
SRC_URI="https://erratique.ch/software/logs/releases/${P}.tbz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+fmt cli +lwt"
# Tests require (unpackaged) b0 build system
RESTRICT="test"

RDEPEND="
	>=dev-lang/ocaml-4.14
	dev-ml/result:=[ocamlopt]
	fmt? ( dev-ml/fmt:= )
	cli? ( dev-ml/cmdliner:=[ocamlopt] )
	lwt? ( dev-ml/lwt:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-ml/findlib
	dev-ml/ocamlbuild
	dev-ml/opam-installer
	dev-ml/topkg
"

src_compile() {
	ocaml pkg/pkg.ml build \
		--with-js_of_ocaml-compiler false \
		--with-fmt $(usex fmt true false) \
		--with-cmdliner $(usex cli true false) \
		--with-lwt $(usex lwt true false) \
		--with-base-threads true \
		|| die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die

	einstalldocs
}
