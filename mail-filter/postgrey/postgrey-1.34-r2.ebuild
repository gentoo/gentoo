# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils user

DESCRIPTION="Postgrey is a Postfix policy server implementing greylisting"
HOMEPAGE="http://postgrey.schweikert.ch/"
SRC_URI="http://postgrey.schweikert.ch/pub/${P}.tar.gz
	http://postgrey.schweikert.ch/pub/old/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="targrey"

DEPEND=""
RDEPEND=">=dev-lang/perl-5.6.0
	dev-perl/net-server
	dev-perl/IO-Multiplex
	dev-perl/BerkeleyDB
	dev-perl/Net-DNS
	dev-perl/Parse-Syslog
	dev-perl/Net-RBLClient
	>=sys-libs/db-4.1"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /dev/null ${PN}
}

src_prepare() {
	if use targrey ; then
		epatch "${FILESDIR}"/targrey-0.31-postgrey-1.34.patch
	fi
	sed -i 's@#!/usr/bin/perl -T -w@#!/usr/bin/perl -w@' postgrey || die "sed failed"
}

src_install() {
	# postgrey data/DB in /var
	diropts -m0770 -o ${PN} -g ${PN}
	dodir /var/spool/postfix/${PN}
	keepdir /var/spool/postfix/${PN}
	fowners postgrey:postgrey /var/spool/postfix/${PN}
	fperms 0770 /var/spool/postfix/${PN}

	# postgrey binary
	dosbin ${PN}
	dosbin contrib/postgreyreport

	# policy-test script
	dosbin policy-test

	# postgrey data in /etc/postfix
	insinto /etc/postfix
	insopts -o root -g ${PN} -m 0640
	doins postgrey_whitelist_clients postgrey_whitelist_recipients

	# documentation
	dodoc Changes README

	# init.d + conf.d files
	insopts -o root -g root -m 755
	newinitd "${FILESDIR}"/${PN}.rc.new ${PN}
	insopts -o root -g root -m 640
	newconfd "${FILESDIR}"/${PN}.conf.new ${PN}
}
