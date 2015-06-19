# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcptrace/tcptrace-6.6.7-r2.ebuild,v 1.4 2015/04/26 04:47:45 jer Exp $

EAPI=5

inherit autotools eutils flag-o-matic

DESCRIPTION="A Tool for analyzing network packet dumps"
HOMEPAGE="http://www.tcptrace.org/"
SRC_URI="
	http://www.tcptrace.org/download/${P}.tar.gz
	http://www.tcptrace.org/download/old/6.6/${P}.tar.gz
"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE=""

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cross-compile.patch
	eautoreconf
	append-cppflags -D_BSD_SOURCE
}

src_compile() {
	emake CCOPT="${CFLAGS}"
}

src_install() {
	dobin tcptrace xpl2gpl

	newman tcptrace.man tcptrace.1
	dodoc CHANGES COPYRIGHT FAQ README* THANKS WWW
}

pkg_postinst() {
	if ! has_version ${CATEGORY}/${PN}; then
		elog "Note: tcptrace outputs its graphs in the xpl (xplot)"
		elog "format. Since xplot is unavailable, you will have to"
		elog "use the included xpl2gpl utility to convert it to"
		elog "the gnuplot format."
	fi
}
