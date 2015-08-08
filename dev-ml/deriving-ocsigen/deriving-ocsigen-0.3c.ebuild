# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib

DESCRIPTION="A deriving library for Ocsigen"
HOMEPAGE="http://ocsigen.org"
SRC_URI="http://www.ocsigen.org/download/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt type-conv"

DEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt?]
	|| ( dev-ml/camlp4:= <dev-lang/ocaml-4.02.0 )
	type-conv? ( >=dev-ml/type-conv-108:= )"
RDEPEND="${DEPEND}"

src_prepare() {
	find . -type f -exec sed -i 's/type-conv/type_conv/g' {} +
}

src_configure() {
	use type-conv || echo "TYPECONV :=" >> Makefile.config
}

src_compile() {
	if use ocamlopt; then
		emake
	else
		emake byte
	fi
}

src_test() {
	emake tests
}

src_install() {
	findlib_src_preinst
	if use ocamlopt; then
		emake install
	else
		emake install-byte
	fi
	dodoc CHANGES README
}
