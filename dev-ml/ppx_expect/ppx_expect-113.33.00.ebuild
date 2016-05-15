# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit oasis

DESCRIPTION="Cram like framework for OCaml"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-ml/ppx_tools:=
	dev-ml/fieldslib:=
	dev-ml/ppx_assert:=
	dev-ml/ppx_compare:=
	dev-ml/ppx_core:=
	dev-ml/ppx_custom_printf:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_fields_conv:=
	dev-ml/ppx_inline_test:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ppx_sexp_value:=
	dev-ml/ppx_variants_conv:=
	dev-ml/ocaml-re:=
	dev-ml/sexplib:=
	dev-ml/variantslib:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND} dev-ml/opam"

src_configure() {
	emake setup.exe
	OASIS_SETUP_COMMAND="./setup.exe" oasis_src_configure
}

src_compile() {
	emake
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
	dodoc CHANGES.md
}
