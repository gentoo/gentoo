# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnssec-check/dnssec-check-1.13.ebuild,v 1.2 2013/03/02 22:48:59 hwoarang Exp $

EAPI=4

inherit qt4-r2

DESCRIPTION="tests local resolver for support of DNSSEC validation"
HOMEPAGE="http://www.dnssec-tools.org"
SRC_URI="http://www.dnssec-tools.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-dns/dnssec-validator[threads]
	dev-qt/qtdeclarative:4 "
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e '/installPrefix = /s: = .*: = /usr:' \
		-i qmlapplicationviewer/qmlapplicationviewer.pri deployment.pri || die
	sed -e '/Exec=/s:/opt::' \
		-i ${PN}.desktop || die
}

src_configure() {
	eqmake4 ${PN}.pro
}
