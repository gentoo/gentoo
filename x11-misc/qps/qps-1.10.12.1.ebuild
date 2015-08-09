# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit qt4-r2

DESCRIPTION="Visual process manager - Qt version of ps/top"
HOMEPAGE="http://qps.kldp.net/projects/qps/"
SRC_URI="http://kldp.net/frs/download.php/5394/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e '/strip/d' ${PN}.pro || die "sed failed"
}

src_install() {
	dobin ${PN} || die "installing binary failed"
	doman ${PN}.1 || die "installing man page failed"
	dodoc CHANGES || die "installing documentation failed"

	newicon icon/icon.xpm ${PN}.xpm || die "installing icon failed"
	domenu ${PN}.desktop || die "installing desktop file failed"
}
