# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/policyd-weight/policyd-weight-0.1.15.2-r1.ebuild,v 1.3 2013/02/15 19:06:14 ago Exp $

EAPI=4

inherit eutils user

DESCRIPTION="Weighted Policy daemon for Postfix"
HOMEPAGE="http://www.policyd-weight.org/"
SRC_URI="http://www.policyd-weight.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="virtual/perl-Sys-Syslog
	dev-perl/Net-DNS
	>=mail-mta/postfix-2.1"

pkg_setup() {
	enewgroup 'polw'
	enewuser 'polw' -1 -1 -1 'polw'
}

src_compile() { :; }

src_install() {
	exeinto /usr/libexec/postfix
	doexe policyd-weight
	fowners root:wheel /usr/libexec/postfix/policyd-weight

	doman man/man5/*.5 man/man8/*.8
	dodoc *.txt

	sed -i -e "s:^   \$LOCKPATH.*:   \$LOCKPATH = '/var/run/policyd-weight/'; # must be a directory (add:" policyd-weight.conf.sample || die
	insinto /etc
	newins policyd-weight.conf.sample policyd-weight.conf

	newinitd "${FILESDIR}/${PN}.init.d-r1" "${PN}"
}
