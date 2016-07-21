# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit oasis

DESCRIPTION="Library for incremental computations"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-ml/bin-prot:=
	>=dev-ml/core-113.24:=
	dev-ml/fieldslib:=
	dev-ml/ppx_assert:=
	dev-ml/ppx_bench:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_expect:=
	dev-ml/ppx_inline_test:=
	dev-ml/ppx_jane:=
	dev-ml/sexplib:=
	dev-ml/typerep:=
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
