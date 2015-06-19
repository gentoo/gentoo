# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ttcp/ttcp-1.12-r2.ebuild,v 1.5 2014/07/18 03:17:56 jer Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Tool to test TCP and UDP throughput"
HOMEPAGE="
	http://ftp.arl.mil/~mike/ttcp.html
	http://www.netcore.fi/pekkas/linux/ipv6/
"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ppc ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
SRC_URI="
	mirror://gentoo/${P}.tar.bz2
	http://www.netcore.fi/pekkas/linux/ipv6/${PN}.c
"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN} "${DISTDIR}"/${PN}.c || die
}

src_install() {
	dobin ${PN}
	newman sgi-${PN}.1 ${PN}.1
}
