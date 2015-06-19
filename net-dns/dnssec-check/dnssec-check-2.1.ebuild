# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnssec-check/dnssec-check-2.1.ebuild,v 1.1 2014/11/06 19:07:47 xmw Exp $

EAPI=4

inherit eutils qt4-r2

DESCRIPTION="tests local resolver for support of DNSSEC validation"
HOMEPAGE="http://www.dnssec-tools.org"
SRC_URI="http://www.dnssec-tools.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="net-dns/dnssec-validator[threads]
	dev-qt/qtdeclarative:5"
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
