# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/bolt/bolt-1.4.ebuild,v 1.3 2014/11/28 17:39:36 aballier Exp $

EAPI=5

inherit findlib

DESCRIPTION="Logging tool for the Objective Caml language"
HOMEPAGE="http://bolt.x9c.fr/"
SRC_URI="http://bolt.x9c.fr/distrib/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND=">=dev-lang/ocaml-3.11:=[ocamlopt]
	|| ( dev-ml/camlp4:= <dev-lang/ocaml-4.02.0 )"
RDEPEND="${DEPEND}"

src_configure() {
	sh configure
}

src_compile() {
	emake all
	use doc && emake doc
}

src_test() {
	emake tests
}

src_install() {
	findlib_src_install
	dodoc README CHANGES FEATURES
	use doc && dohtml ocamldoc/*
}
