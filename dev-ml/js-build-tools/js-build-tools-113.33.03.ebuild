# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Collection of tools to help building Jane Street Packages"
HOMEPAGE="https://github.com/janestreet/js-build-tools"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND} dev-ml/opam"

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
	dodoc README.md
}
