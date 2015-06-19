# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/kccmp/kccmp-0.3.ebuild,v 1.4 2013/03/02 23:37:29 hwoarang Exp $

EAPI="4"
inherit qt4-r2

DESCRIPTION="A simple tool for comparing two linux kernel .config files"
HOMEPAGE="http://stoopidsimple.com/kccmp/"
SRC_URI="http://stoopidsimple.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

src_prepare() {
	qt4-r2_src_prepare
	echo "DEFINES += KCCMP_QT_4" >> ${PN}.pro
}

src_install() {
	dobin kccmp
	dodoc README
}
