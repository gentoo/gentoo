# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/macaque/macaque-0.6.1.ebuild,v 1.1 2013/02/07 20:43:32 aballier Exp $

EAPI=5

inherit findlib

DESCRIPTION="DSL for SQL Queries in Caml"
HOMEPAGE="http://forge.ocamlcore.org/projects/macaque/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1027/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-ml/pgocaml:=
	dev-lang/ocaml:="
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}/src"

src_compile() {
	emake -j1
}

src_install() {
	findlib_src_preinst
	emake -j1 install
	dodoc ../README Changelog
}
