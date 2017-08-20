# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Base set of ppx rewriters"
HOMEPAGE="https://github.com/janestreet/ppx_base"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-lang/ocaml:=
	dev-ml/ppx_compare:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_enumerate:=
	dev-ml/ppx_hash:=
	dev-ml/ppx_js_style:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ppx_type_conv:=
	dev-ml/ocaml-migrate-parsetree:=
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
