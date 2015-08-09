# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PV=${PV/_p/+}
MY_P=${PN}-${MY_PV}

DESCRIPTION="System for writing extensible parsers for programming languages"
HOMEPAGE="https://github.com/ocaml/camlp4"
SRC_URI="https://github.com/ocaml/camlp4/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-fbsd ~x86-linux"
IUSE="+ocamlopt"

DEPEND=">=dev-lang/ocaml-4.02:=[ocamlopt?]"
RDEPEND="${DEPEND}
	!<dev-lang/ocaml-4.02
	!<dev-ml/findlib-1.5.5-r1"

S=${WORKDIR}/${P/_p/-}

src_configure() {
	./configure \
		--bindir="${EPREFIX}/usr/bin" \
		--libdir="$(ocamlc -where)" \
		--pkgdir="$(ocamlc -where)" \
		|| die
}

src_compile() {
	emake byte
	use ocamlopt && emake native
}

src_install() {
	emake DESTDIR="${D}" install install-META
	dodoc CHANGES.md README.md
}
