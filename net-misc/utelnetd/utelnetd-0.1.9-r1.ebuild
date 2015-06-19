# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/utelnetd/utelnetd-0.1.9-r1.ebuild,v 1.2 2012/03/13 12:00:10 phajdan.jr Exp $

inherit toolchain-funcs

DESCRIPTION="A small Telnet daemon, derived from the Axis tools"
HOMEPAGE="http://www.pengutronix.de/software/utelnetd_en.html"
SRC_URI="http://www.pengutronix.de/software/utelnetd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~s390 ~sparc ~x86"
IUSE=""

DEPEND="virtual/shadow"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "/(STRIP)/d" \
		-e "/^CC/s:=.*:= $(tc-getCC):" \
		Makefile || die
}

src_install() {
	dosbin utelnetd || die
	dodoc ChangeLog README

	newinitd "${FILESDIR}"/utelnetd.initd utelnetd
}
