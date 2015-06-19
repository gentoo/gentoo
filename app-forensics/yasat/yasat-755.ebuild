# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/yasat/yasat-755.ebuild,v 1.1 2014/05/06 07:15:40 patrick Exp $

EAPI=5

inherit eutils

DESCRIPTION="Security and system auditing tool"
HOMEPAGE="http://yasat.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

S=${WORKDIR}/${PN}

src_compile() { :; }

src_install() {
	emake install DESTDIR="${D}" PREFIX="/usr" SYSCONFDIR="/etc"

	dodoc README CHANGELOG
	doman man/yasat.8
}
