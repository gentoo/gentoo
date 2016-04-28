# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Authentication and accounting server for terminal servers that speak the RADIUS protocol"
HOMEPAGE="http://www.radius.cistron.nl/"
SRC_URI="ftp://ftp.radius.cistron.nl/pub/radius/radiusd-cistron-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* x86"

DEPEND="
	!net-dialup/freeradius
	!net-dialup/gnuradius"
RDEPEND="${DEPEND}"

S="${WORKDIR}/radiusd-cistron-${PV}"

src_prepare() {
	epatch "${FILESDIR}/${P}-gcc41.patch"
	sed -i -e "s:SHAREDIR/::g" raddb/dictionary || die
	mv src/checkrad.pl src/checkrad || die

	epatch_user
}

src_compile() {
	emake -C src \
	    CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
	    BINDIR=/usr/bin SBINDIR=/usr/sbin \
	    MANDIR=/usr/share/man SHAREDIR=/usr/share/radius
}

src_install() {
	insinto /etc/raddb
	doins raddb/*
	dodoc README doc/{ChangeLog,FAQ.txt,README*}
	doman doc/{*.1,*.8,*.5rad,*.8rad}

	dosbin src/{checkrad,radiusd,radrelay}
	dobin src/{radclient,radlast,radtest,radwho,radzap}

	newinitd "${FILESDIR}/cistronradius.rc" cistronradius
}
