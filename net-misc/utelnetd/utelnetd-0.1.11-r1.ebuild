# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A small Telnet daemon, derived from the Axis tools"
HOMEPAGE="http://www.pengutronix.de/software/utelnetd/index_en.html"
SRC_URI="http://www.pengutronix.de/software/utelnetd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~s390 ~sparc ~x86"
IUSE=""

DEPEND="virtual/shadow"

src_prepare() {
	sed -i \
		-e "/(STRIP)/d" \
		-e "/^CC/s:=.*:= $(tc-getCC):" \
		-e "/fomit-frame-pointer/d" \
		Makefile || die

	default
}

src_install() {
	dosbin utelnetd
	dodoc ChangeLog README

	newinitd "${FILESDIR}"/utelnetd.initd utelnetd
}
