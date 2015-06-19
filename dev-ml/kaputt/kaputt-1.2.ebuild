# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/kaputt/kaputt-1.2.ebuild,v 1.2 2013/03/10 10:50:33 aballier Exp $

EAPI=5

inherit findlib

DESCRIPTION="Unit testing tool for the Objective Caml language"
HOMEPAGE="http://kaputt.x9c.fr/"
SRC_URI="http://kaputt.x9c.fr/distrib/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/ocaml-3.11:=[ocamlopt]"
RDEPEND="${DEPEND}"

src_configure() {
	chmod +x configure
	./configure || die
}

src_compile() {
	emake all
}

src_test() {
	emake -j1 tests
}

src_install() {
	findlib_src_install
	dodoc README FEATURES CHANGES
}
