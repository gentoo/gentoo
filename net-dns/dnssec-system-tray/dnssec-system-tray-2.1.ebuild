# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnssec-system-tray/dnssec-system-tray-2.1.ebuild,v 1.1 2014/11/06 18:47:04 xmw Exp $

EAPI=4

inherit eutils qt4-r2

DESCRIPTION="display DNSSEC resolver logs in system tray"
HOMEPAGE="http://www.dnssec-tools.org"
SRC_URI="http://www.dnssec-tools.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtgui:4
	dev-qt/qtsvg:4
	dev-qt/qtcore:4"
DEPEND="${RDEPEND}"

src_configure() {
	eqmake4 ${PN}.pro PREFIX=/usr
}

src_install() {
	qt4-r2_src_install

	newicon	images/justlock.png ${PN}.png
	make_desktop_entry ${PN}

	doman man/${PN}.1
}
