# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnssec-system-tray/dnssec-system-tray-1.14.ebuild,v 1.2 2013/03/02 22:49:22 hwoarang Exp $

EAPI=4

inherit eutils qt4-r2

DESCRIPTION="display DNSSEC resolver logs in system tray"
HOMEPAGE="http://www.dnssec-tools.org"
SRC_URI="http://www.dnssec-tools.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtgui:4"
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
