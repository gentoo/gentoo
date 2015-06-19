# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/fetchlog/fetchlog-1.4.ebuild,v 1.1 2013/02/01 12:39:42 phosphan Exp $

inherit toolchain-funcs

DESCRIPTION="Displays the last new messages of a logfile"
HOMEPAGE="http://fetchlog.sourceforge.net/"
SRC_URI="mirror://sourceforge/fetchlog/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc64"

IUSE="snmp"

RDEPEND="snmp? (
	>=dev-perl/Net-SNMP-4.0.1-r2
	>=net-analyzer/net-snmp-5.0.6
	)"

pkg_preinst() {
	elog
	elog "This utility can be used together with Nagios"
	elog "To make use of these features you need to"
	elog "install net-analyzer/nagios."
	elog "This feature depends on SNMP, so make use you"
	elog "have 'snmp' in your USE flags"
	elog
}

src_compile() {
	# Links the .c file straight to the binary
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${LDFLAGS}" || die
}

src_install() {
	dodoc CHANGES README*
	dodoc *cfg*
	dobin fetchlog
	doman fetchlog.1
}
