# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils qt4-r2

DESCRIPTION="A graphical file and directories comparator and merge tool"
HOMEPAGE="http://furius.ca/xxdiff/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-qt/qtgui:4
	!>=sys-devel/bison-3"
DEPEND="${RDEPEND}
	virtual/yacc"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc47.patch

	pushd src >/dev/null
	sed -i -e '/qPixmapFromMimeSource/d' *.ui || die #365019
	qt4-r2_src_prepare
	popd

	distutils-r1_src_prepare
}

src_configure() {
	pushd src >/dev/null
	qt4-r2_src_configure
	cat Makefile.extra >> Makefile
	popd

	distutils-r1_src_configure
}

src_compile() {
	pushd src >/dev/null
	qt4-r2_src_compile
	popd

	distutils-r1_src_compile
}

src_install() {
	dobin bin/xxdiff

	distutils-r1_src_install

	dodoc CHANGES README* TODO doc/*.txt src/doc.txt

	dohtml doc/*.{png,html} src/doc.html

	# example tools, use these to build your own ones
	insinto /usr/share/doc/${PF}
	doins -r tools
}
