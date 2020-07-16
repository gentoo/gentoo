# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Displays the last new messages of a logfile"
HOMEPAGE="http://fetchlog.sourceforge.net/"
SRC_URI="mirror://sourceforge/fetchlog/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="snmp"

RDEPEND="
	snmp? (
		>=dev-perl/Net-SNMP-4.0.1-r2
		>=net-analyzer/net-snmp-5.0.6
	)"
DEPEND=""

PATCHES=( "${FILESDIR}"/${PN}-1.4-fix-build-system.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin fetchlog
	einstalldocs
	dodoc *cfg*
	doman fetchlog.1
}

pkg_preinst() {
	elog
	elog "This utility can be used together with Nagios"
	elog "To make use of these features you need to"
	elog "install net-analyzer/nagios."
	elog "This feature depends on SNMP, so make use you"
	elog "have 'snmp' in your USE flags"
	elog
}
