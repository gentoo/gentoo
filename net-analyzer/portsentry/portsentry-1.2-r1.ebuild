# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/portsentry/portsentry-1.2-r1.ebuild,v 1.7 2015/05/27 08:25:46 ago Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Automated port scan detector and response tool"
# Seems like CISCO took the site down?
HOMEPAGE="http://sourceforge.net/projects/sentrytools/"
SRC_URI="mirror://sourceforge/sentrytools/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"

S="${WORKDIR}"/${PN}_beta

src_prepare() {
	epatch "${FILESDIR}"/${P}-conf.patch
	epatch "${FILESDIR}"/${P}-config.h.patch
	epatch "${FILESDIR}"/${P}-gcc.patch
	epatch "${FILESDIR}"/${P}-ignore.csh.patch
}

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS} ${LDFLAGS}" linux
}

src_install() {
	doman "${FILESDIR}"/{portsentry.8,portsentry.conf.5}

	dobin portsentry ignore.csh
	dodoc README* CHANGES CREDITS
	newdoc portsentry.ignore portsentry.ignore.sample
	newdoc portsentry.conf portsentry.conf.sample

	insinto /etc/portsentry
	newins portsentry.ignore portsentry.ignore.sample
	newins portsentry.conf portsentry.conf.sample

	newinitd "${FILESDIR}"/portsentry.rc6 portsentry
	newconfd "${FILESDIR}"/portsentry.confd portsentry
}
