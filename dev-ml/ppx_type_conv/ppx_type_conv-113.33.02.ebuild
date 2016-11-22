# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit oasis eutils

DESCRIPTION="Support Library for type-driven code generators"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${P}+4.03.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-ml/ppx_tools:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_deriving:=
	dev-ml/ppx_core:=
	dev-ml/ppx_optcomp:=
	>=dev-lang/ocaml-4.03:=
"

RDEPEND="${DEPEND}"
DEPEND="${DEPEND} dev-ml/opam"

S=${WORKDIR}/${P}+4.03

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
