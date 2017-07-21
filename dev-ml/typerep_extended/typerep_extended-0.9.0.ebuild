# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Runtime types for OCaml (Extended)"
HOMEPAGE="https://github.com/janestreet/typerep_extended"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-lang/ocaml:=
	dev-ml/bin-prot:=
	dev-ml/core_kernel:=
	dev-ml/ppx_bin_prot:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ppx_sexp_value:=
	dev-ml/ppx_type_conv:=
	dev-ml/ppx_typerep_conv:=
	dev-ml/sexplib:=
	dev-ml/typerep:=
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
