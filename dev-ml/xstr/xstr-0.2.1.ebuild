# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib

DESCRIPTION="Thread-safe implementation of string searching/matching/splitting"
HOMEPAGE="http://www.ocaml-programming.de/packages/"
SRC_URI="http://www.ocaml-programming.de/packages/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND=">=dev-lang/ocaml-3.10:=[ocamlopt]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_compile()
{
	make all || die
	make opt || die
}

src_install()
{
	findlib_src_install
	dodoc README RELEASE
}
