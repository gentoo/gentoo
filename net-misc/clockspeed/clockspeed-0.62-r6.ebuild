# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils flag-o-matic

DESCRIPTION="A simple Network Time Protocol (NTP) client"
HOMEPAGE="http://cr.yp.to/clockspeed.html"

# this is the trailing part of the name for the latest leapseconds file.
LEAPSECONDS_DATE="20081114"

SRC_URI="http://cr.yp.to/clockspeed/${P}.tar.gz
	http://dev.gentoo.org/~pacho/maintainer-needed/leapsecs.dat."$LEAPSECONDS_DATE""

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 ~mips x86"
IUSE="static selinux"
RESTRICT="mirror bindist test"

DEPEND="sys-apps/groff"
RDEPEND="selinux? ( sec-policy/selinux-clockspeed )
	net-dns/djbdns"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_configure() {
	echo "$(tc-getCC) ${CFLAGS} ${ASFLAGS}" > conf-cc
	use static && append-ldflags -static
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
}

src_install() {
	dobin clockspeed clockadd clockview sntpclock taiclock taiclockd
	dosbin "${FILESDIR}"/ntpclockset

	doman *.1
	dodoc BLURB CHANGES INSTALL README THANKS TODO

	insinto /var/lib/clockspeed
	newins "${DISTDIR}"/leapsecs.dat."$LEAPSECONDS_DATE" leapsecs.dat
}
