# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/qtexengine/qtexengine-0.3.ebuild,v 1.5 2015/01/25 23:53:10 pesa Exp $

EAPI=5

inherit qt4-r2

MY_PN=QTeXEngine

DESCRIPTION="TeX support for Qt"
HOMEPAGE="http://soft.proindependent.com/qtexengine/"
SRC_URI="mirror://sourceforge/qtiplot.berlios/${MY_PN}-${PV}-opensource.zip"

KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="GPL-3"
IUSE=""

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_PN}

PATCHES=(
	"${FILESDIR}/${P}-dynlib.patch"
)

src_compile() {
	emake sub-src-all
}

src_test() {
	emake sub-test-all
}

src_install() {
	dolib.so lib${MY_PN}.so*
	doheader src/${MY_PN}.h
	dodoc CHANGES.txt
	dodoc -r doc/html
}
