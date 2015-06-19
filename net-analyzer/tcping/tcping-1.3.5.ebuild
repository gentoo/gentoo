# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcping/tcping-1.3.5.ebuild,v 1.1 2012/05/24 07:45:41 xmw Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Ping implementation that uses the TCP protocol"
HOMEPAGE="http://www.linuxco.de/tcping/tcping.html"
SRC_URI="http://www.linuxco.de/tcping/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	sed -e '/^CC=/s:=:?=:' \
		-e '/^CCFLAGS/s:=:+=:' \
		-e 's/$(CCFLAGS)/$(CCFLAGS) $(LDFLAGS)/' \
		-i Makefile || die
	tc-export CC
	export CCFLAGS="${CFLAGS}"
}

src_install() {
	dobin tcping
	dodoc README
}
