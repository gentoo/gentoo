# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils qt4-r2

DESCRIPTION="Visual process manager - Qt version of ps/top"
HOMEPAGE="http://qps.kldp.net/projects/qps/"
SRC_URI="http://kldp.net/frs/download.php/5963/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e '/strip/d' ${PN}.pro || die "sed failed"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc CHANGES

	newicon icon/icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} ${PN} ${PN} "System;"
}
