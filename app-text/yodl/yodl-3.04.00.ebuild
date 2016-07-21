# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Your Own Document Language: a pre-document language and tools to process it"
HOMEPAGE="http://yodl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-util/icmake"

src_prepare() {
	sed -e "/DOC.* =/s/yodl\(-doc\)\?/${PF}/" \
		-e "/COMPILER =/s/gcc/$(tc-getCC)/" \
		-e "/CXX =/s/g++/$(tc-getCXX)/" \
		-i INSTALL.im || die

	sed -e "s/ar ru/$(tc-getAR) ru/" \
		-e "s/ranlib/$(tc-getRANLIB)/" \
		-i icmake/stdcompile || die
}

src_compile() {
	./build programs || die
	./build man || die
	use doc && { ./build manual || die ; }
	./build macros || die
}

src_install() {
	./build install programs "${ED}" || die
	./build install man "${ED}" || die
	./build install macros "${ED}" || die
	./build install docs "${ED}" || die
	use doc && { ./build install manual "${ED}" || die ; }
}
