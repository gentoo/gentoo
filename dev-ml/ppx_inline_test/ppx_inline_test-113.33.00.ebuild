# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit oasis eutils

MY_P=${PN/-/_}-${PV}
DESCRIPTION="Syntax extension for writing in-line tests in ocaml code"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-ml/ppx_tools:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_core:="

RDEPEND="${DEPEND}"
DEPEND="${DEPEND} dev-ml/opam"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	has_version '>=dev-lang/ocaml-4.03' && epatch "${FILESDIR}/oc43.patch"
}

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
