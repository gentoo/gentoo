# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils qt4-r2

DESCRIPTION="graphically depicts the DNSSEC results from a lookup via logfiles"
HOMEPAGE="https://www.dnssec-tools.org"
SRC_URI="https://www.dnssec-tools.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=net-dns/dnssec-validator-${PV}-r1[threads]
	dev-qt/qtcore:4"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-unused-libs.patch )

src_configure() {
	eqmake4 ${PN}.pro PREFIX=/usr
}

src_install() {
	qt4-r2_src_install

	doicon icons/dnssec-nodes.*
	make_desktop_entry ${PN}

	doman man/${PN}.1
}
