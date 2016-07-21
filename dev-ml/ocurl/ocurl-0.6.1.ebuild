# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib

DESCRIPTION="OCaml interface to the libcurl library"
HOMEPAGE="http://forge.ocamlcore.org/projects/ocurl/"
LICENSE="MIT"
SRC_URI="https://forge.ocamlcore.org/frs/download.php/1374/${P}.tgz"

SLOT="0/${PV}"
IUSE="examples"

RDEPEND=">=net-misc/curl-7.9.8
		>=dev-lang/ocaml-3.12:=[ocamlopt]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
KEYWORDS="amd64 ppc x86"

src_compile()
{
	emake -j1 all
}

src_install()
{
	findlib_src_install
	dodoc CHANGES.txt README
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
