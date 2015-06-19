# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mtop/mtop-0.6.6-r3.ebuild,v 1.1 2014/05/08 01:19:27 grknight Exp $

EAPI=5
inherit perl-module

DESCRIPTION="Mysql top monitors a MySQL server"
HOMEPAGE="http://mtop.sourceforge.net"
SRC_URI="mirror://sourceforge/mtop/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="dev-perl/Curses
	dev-perl/DBI
	dev-perl/DBD-mysql
	virtual/perl-libnet"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/mtop-0.6.6-globalstatusfix.patch )
DOCS=( ChangeLog README README.devel )

warnmsg() {
	einfo "Upstream no longer maintains mtop. You should consider dev-db/mytop instead."
}

pkg_postinst() {
	warnmsg
}

pkg_preinst() {
	warnmsg
}
