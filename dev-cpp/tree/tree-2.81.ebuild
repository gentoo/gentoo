# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="An STL-like tree class"
HOMEPAGE="http://www.aei.mpg.de/~peekas/tree/"
SRC_URI="http://www.aei.mpg.de/~peekas/tree/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc"

S="${WORKDIR}/${P}/src"

PATCHES=( "${FILESDIR}"/${P}-test.patch )

src_configure() {
	tc-export CXX
}

src_install() {
	doheader tree.hh tree_util.hh
	dodoc tree_example.cc

	if use doc; then
		dodoc ../doc/treefig.*
		rm ../doc/treefig.* || die

		docinto html
		rm ../doc/{doxygen_tree.config,favicon.ico,tree.tex} || die
		dodoc -r ../doc/.
	fi
	docompress -x /usr/share/doc/${PF}
}
