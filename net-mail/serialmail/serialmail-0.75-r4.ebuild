# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/serialmail/serialmail-0.75-r4.ebuild,v 1.7 2014/08/10 20:46:30 slyfox Exp $

EAPI=4

inherit eutils

DESCRIPTION="A serialmail is a collection of tools for passing mail across serial links"
HOMEPAGE="http://cr.yp.to/serialmail.html"
SRC_URI="http://cr.yp.to/software/${P}.tar.gz
	mirror://gentoo/${P}-patch.tar.bz2"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="static"
RESTRICT="mirror bindist"

DEPEND="sys-apps/groff
	>=sys-apps/ucspi-tcp-0.88"

RDEPEND="sys-apps/groff
	>=sys-apps/ucspi-tcp-0.88
	virtual/daemontools"

src_prepare() {
	epatch "${WORKDIR}"/${P}-gentoo.patch
	epatch "${WORKDIR}"/${P}-smtpauth.patch
	epatch "${WORKDIR}"/${P}-smtpauth_comp.patch
	sed -i "s:@CFLAGS@:${CFLAGS}:" conf-cc
	use static && LDFLAGS="${LDFLAGS} -static"
	sed -i "s:@LDFLAGS@:${LDFLAGS}:" conf-ld
	epatch "${FILESDIR}"/${P}-implicit.patch
}

src_compile() {
	grep -v man hier.c | grep -v doc > hier.c.tmp ; mv hier.c.tmp hier.c
	emake it man
}

src_install() {
	dobin serialsmtp serialqmtp maildirsmtp maildirserial maildirqmtp

	dodoc AUTOTURN CHANGES FROMISP SYSDEPS THANKS TOISP \
		BLURB FILES INSTALL README TARGETS TODO VERSION

	doman maildirqmtp.1 maildirserial.1 maildirsmtp.1 \
		serialqmtp.1 serialsmtp.1
}
