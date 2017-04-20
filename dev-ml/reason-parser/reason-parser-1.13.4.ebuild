# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib eutils

DESCRIPTION="Meta Language Toolchain"
HOMEPAGE="https://github.com/facebook/reason"
SRC_URI="https://github.com/facebook/reason/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

DEPEND="
	dev-lang/ocaml:=[ocamlopt?]
	>=dev-ml/menhir-20170418:=
	dev-ml/merlin-extend:=
	dev-ml/result:=
	dev-ml/topkg:=
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/ppx_tools_versioned:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/ocamlbuild
	dev-ml/opam
"

S="${WORKDIR}/reason-${PV}/${PN}"

src_prepare() {
	epatch "${FILESDIR}/menhir.patch"
	default
}

src_compile() {
	emake compile_error
	ocamlbuild -package topkg pkg/build.native || die
	./build.native build \
		--native "$(usex ocamlopt true false)" \
		--native-dynlink "$(usex ocamlopt true false)" \
		|| die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		--mandir="${ED}/usr/share/man" \
		${PN}.install || die
}
