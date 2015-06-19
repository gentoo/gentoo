# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/yasat/yasat-526.ebuild,v 1.2 2012/11/23 13:18:23 ago Exp $

EAPI=5

DESCRIPTION="Security and system auditing tool"
HOMEPAGE="http://yasat.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_compile() { :; }

src_install() {
	emake install DESTDIR="${D}" PREFIX="/usr" SYSCONFDIR="/etc"
	dodoc README CHANGELOG
	doman man/yasat.8
}
