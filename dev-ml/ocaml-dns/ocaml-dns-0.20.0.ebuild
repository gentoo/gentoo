# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib

DESCRIPTION="A pure OCaml implementation of the DNS protocol"
HOMEPAGE="https://github.com/mirage/ocaml-dns https://mirage.io"
SRC_URI="https://github.com/mirage/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2 LGPL-2.1-with-linking-exception ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="async +lwt +ocamlopt test"

RDEPEND="
	async? ( >=dev-ml/async-112.24.00:= )
	lwt? ( >=dev-ml/lwt-2.4.7:=
		dev-ml/ocaml-cstruct:=[lwt(-)] )
	>=dev-lang/ocaml-4:=
	dev-ml/cmdliner:=
	dev-ml/mirage-profile:=
	>=dev-ml/ocaml-base64-2.0.0:=
	>=dev-ml/ocaml-cstruct-1.9.0:=
	>=dev-ml/ocaml-ipaddr-2.6.0:=
	dev-ml/ocaml-re:=
	>=dev-ml/ocaml-uri-1.7.0:=
	dev-ml/ocaml-hashcons:=[ocamlopt?]
	dev-lang/ocaml:=[ocamlopt?]
	!<dev-ml/mirage-types-1.2.0
	!dev-ml/odns
"
DEPEND="
	test? (
		dev-ml/ounit
		dev-ml/ocaml-pcap
	)
	dev-ml/topkg
	dev-ml/ppx_tools
	${RDEPEND}
"
# Missing mirage deps
RESTRICT="test"

src_compile() {
	ocaml pkg/pkg.ml build \
		--tests $(usex test true false) \
		--with-lwt $(usex lwt true false) \
		--with-async $(usex async true false) \
		|| die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		dns.install || die
	dodoc CHANGES.md README.md TODO.md
}
