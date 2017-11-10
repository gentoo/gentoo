# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="System-independent part of Core"
HOMEPAGE="https://github.com/janestreet/core_kernel"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-lang/ocaml:=
	dev-ml/base:=
	dev-ml/bin-prot:=
	dev-ml/configurator:=
	dev-ml/fieldslib:=
	dev-ml/jane-street-headers:=
	dev-ml/ppx_assert:=
	dev-ml/ppx_base:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_hash:=
	dev-ml/ppx_inline_test:=
	dev-ml/ppx_jane:=
	dev-ml/ppx_sexp_conv:=
	dev-ml/ppx_sexp_message:=
	dev-ml/sexplib:=
	dev-ml/stdio:=
	dev-ml/typerep:=
	dev-ml/variantslib:=
	dev-ml/ocaml-migrate-parsetree:=
"
DEPEND="${RDEPEND}
	dev-ml/opam
	dev-ml/jbuilder
"

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
}
