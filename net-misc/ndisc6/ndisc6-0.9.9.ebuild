# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ndisc6/ndisc6-0.9.9.ebuild,v 1.4 2010/11/06 01:56:29 xmw Exp $

DESCRIPTION="Recursive DNS Servers discovery Daemon (rdnssd) for IPv6"
HOMEPAGE="http://www.remlab.net/ndisc6/"
SRC_URI="http://www.remlab.net/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND="dev-lang/perl
	sys-devel/gettext"
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die
	newinitd "${FILESDIR}"/rdnssd.rc rdnssd || die
	newconfd "${FILESDIR}"/rdnssd.conf rdnssd || die
	exeinto /etc/rdnssd
	doexe "${FILESDIR}"/resolvconf || die
	dodoc AUTHORS ChangeLog NEWS README || die
}
