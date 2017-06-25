# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Binary protocol generator"
HOMEPAGE="https://github.com/janestreet/bin_prot"
SRC_URI="https://github.com/janestreet/bin_prot/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-lang/ocaml:=
	dev-ml/base:=
	dev-ml/ppx_compare:=
	dev-ml/ppx_custom_printf:=
	dev-ml/ppx_core:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_fields_conv:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ppx_type_conv:=
	dev-ml/ppx_variants_conv:=
	dev-ml/sexplib:=
	dev-ml/ocaml-migrate-parsetree:=
"
DEPEND="${RDEPEND} dev-ml/opam dev-ml/jbuilder"

S="${WORKDIR}/bin_prot-${PV}"

src_test() {
	jbuilder runtest || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN/-/_}.install || die
	dodoc CHANGES.md README.md
}
