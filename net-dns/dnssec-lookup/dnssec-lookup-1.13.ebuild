# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit qt4-r2

MY_PN=${PN/dnssec-/}
MY_P=${MY_PN}-${PV}
DESCRIPTION="DNS lookup utility that supports DNSSEC validation"
HOMEPAGE="http://www.dnssec-tools.org"
SRC_URI="http://www.dnssec-tools.org/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="net-dns/dnssec-validator[threads]
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	eqmake4 ${MY_PN}.pro PREFIX=/usr
}

src_install() {
	newbin src/build/${MY_PN} ${PN}

	newicon data/64x64/${MY_PN}.png ${PN}.png
	newicon data/maemo/${MY_PN}.xpm ${PN}.xpm
	make_desktop_entry ${PN}

	newman man/${MY_PN}.1 ${PN}.1
}
