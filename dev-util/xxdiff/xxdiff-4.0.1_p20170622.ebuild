# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 qmake-utils

DESCRIPTION="A graphical file and directories comparator and merge tool"
HOMEPAGE="http://furius.ca/xxdiff/"
# generated as 'hg archive xxdiff-${P}.tar'
# from https://bitbucket.org/blais/xxdiff tree
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
SRC_URI="https://dev.gentoo.org/~slyfox/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
DEPEND="
	${RDEPEND}
	virtual/yacc
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.1-no-throw-in-dtor.patch
	"${FILESDIR}"/${P}-cxx11.patch
)

src_configure() {
	pushd src >/dev/null || die
		# mimic src/Makefile.bootstrap
		eqmake5
		cat Makefile.extra >> Makefile || die
	popd

	distutils-r1_src_configure
}

src_compile() {
	emake -C src MAKEDIR=.

	distutils-r1_src_compile
	HTML_DOCS+=(
		doc/*.{png,html}
		src/doc.html
	)
}

src_install() {
	dobin bin/xxdiff

	distutils-r1_src_install

	dodoc CHANGES README* TODO doc/*.txt src/doc.txt

	# example tools, use these to build your own ones
	dodoc -r tools
}
