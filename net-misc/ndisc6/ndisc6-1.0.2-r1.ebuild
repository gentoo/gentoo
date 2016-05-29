# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Recursive DNS Servers discovery Daemon (rdnssd) for IPv6"
HOMEPAGE="http://www.remlab.net/ndisc6/"
SRC_URI="http://www.remlab.net/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug"

DEPEND="dev-lang/perl
	sys-devel/gettext"
RDEPEND=""

src_configure() {
	econf $(use_enable debug assert)
}

src_install() {
	emake DESTDIR="${D}" install || die
	newinitd "${FILESDIR}"/rdnssd.rc-1 rdnssd || die
	newconfd "${FILESDIR}"/rdnssd.conf rdnssd || die
	exeinto /etc/rdnssd
	newexe "${FILESDIR}"/resolvconf-1 resolvconf || die
	dodoc AUTHORS ChangeLog NEWS README || die
}
