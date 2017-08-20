# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Websocket library for OCaml"
HOMEPAGE="https://github.com/vbmithr/ocaml-websocket"
SRC_URI="https://github.com/vbmithr/ocaml-websocket/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt async +ssl lwt"

DEPEND="
	dev-lang/ocaml:=[ocamlopt?]
	dev-ml/astring:=[ocamlopt(+)?]
	dev-ml/ocaml-cohttp:=[ocamlopt(+)?,async?,lwt?]
	dev-ml/cppo:=[ocamlopt(+)?]
	dev-ml/ocplib-endian:=[ocamlopt(+)?]
	async? (
		dev-ml/async:=[ocamlopt(+)?]
		ssl? ( dev-ml/async_ssl:=[ocamlopt(+)?] )
	)
	lwt? ( dev-ml/lwt:=[ocamlopt(+)?] )
	ssl? ( dev-ml/cryptokit:=[ocamlopt(+)?] )

"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/opam
	dev-ml/ocamlbuild"

src_compile() {
	ocaml pkg/build.ml \
		native=$(usex ocamlopt true false) \
		native-dynlink=$(usex ocamlopt true false) \
		lwt=$(usex lwt true false) \
		async=$(usex async true false) \
		async_ssl=$(usex async "$(usex ssl true false)" false) \
		nocrypto=false \
		cryptokit=$(usex ssl true false) \
		test=false \
		|| die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		websocket.install || die
	dodoc README CHANGES
}
