# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocaml-expat/ocaml-expat-0.9.1.ebuild,v 1.6 2013/08/19 13:33:11 aballier Exp $

EAPI=5

inherit findlib eutils

IUSE="doc +ocamlopt test"

DESCRIPTION="OCaml bindings for expat"
SRC_URI="http://www.xs4all.nl/~mmzeeman/ocaml/${P}.tar.gz"
HOMEPAGE="http://www.xs4all.nl/~mmzeeman/ocaml/"

RDEPEND="dev-libs/expat
	>=dev-lang/ocaml-3.10.2:=[ocamlopt?]"

DEPEND="${RDEPEND}
	test? ( dev-ml/ounit )"

SLOT="0/${PV}"
LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~x86"

src_prepare(){
	epatch "${FILESDIR}/${P}-test.patch"
}

src_compile() {
	emake depend
	emake all
	if use ocamlopt; then
		emake allopt
	fi
}

src_test() {
	emake test
	if use ocamlopt; then
		emake testopt
	fi
}
src_install() {
	findlib_src_preinst
	emake install

	if use doc ; then
		dohtml -r doc/html/*
	fi
	dodoc README
}
