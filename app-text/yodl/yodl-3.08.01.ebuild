# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Your Own Document Language: a pre-document language and tools to process it"
HOMEPAGE="https://fbb-git.github.io/yodl/ https://github.com/fbb-git/yodl"
SRC_URI="https://github.com/fbb-git/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=dev-util/icmake-8.00.00"

S=${WORKDIR}/${P}/${PN}

src_prepare() {
	sed -e "/DOC.* =/s/yodl\(-doc\)\?/${PF}/" \
		-e "/COMPILER =/s/gcc/$(tc-getCC)/" \
		-e "/CXX =/s/g++/$(tc-getCXX)/" \
		-i INSTALL.im || die

	sed -e "s/ar r /$(tc-getAR) r /" \
		-e "s/ranlib/$(tc-getRANLIB)/" \
		-i icmake/stdcompile || die

	default
}

src_compile() {
	./build programs || die
	./build macros || die
	./build man || die
	use doc && { ./build manual || die ; }
}

src_install() {
	./build install programs "${ED}" || die
	./build install macros "${ED}" || die
	./build install man "${ED}" || die
	./build install docs "${ED}" || die
	use doc && { ./build install manual "${ED}" || die ; }
}
