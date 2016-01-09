# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils qmake-utils

DESCRIPTION="tests local resolver for support of DNSSEC validation"
HOMEPAGE="http://www.dnssec-tools.org"
SRC_URI="http://www.dnssec-tools.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-dns/dnssec-validator[threads]
	dev-qt/qtdeclarative:5"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e '/Exec=/s:/opt::' \
		-i ${PN}.desktop || die
}

src_configure() {
	eqmake5 ${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}usr" install

	doicon ${PN}.png
	domenu ${PN}.desktop
}
