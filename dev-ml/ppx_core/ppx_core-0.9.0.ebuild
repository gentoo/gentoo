# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Standard library for ppx rewriters"
HOMEPAGE="https://github.com/janestreet/ppx_core"
SRC_URI="https://github.com/janestreet/ppx_core/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-lang/ocaml:=
	dev-ml/base:=
	dev-ml/ocaml-compiler-libs:=
	dev-ml/ppx_ast:=
	dev-ml/ppx_traverse_builtins:=
	dev-ml/stdio:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND} dev-ml/opam dev-ml/jbuilder"

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
}
