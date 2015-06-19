# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/fastforward/fastforward-0.51-r1.ebuild,v 1.9 2012/12/22 16:51:13 ulm Exp $

inherit eutils fixheadtails

DESCRIPTION="handle qmail forwarding according to a cdb database"
HOMEPAGE="http://cr.yp.to/fastforward.html"
SRC_URI="http://cr.yp.to/software/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="x86 sparc ~ppc"
IUSE=""

DEPEND="sys-apps/groff"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-errno.patch"
	ht_fix_file Makefile

	echo "gcc ${CFLAGS}" > conf-cc
	echo "gcc" > conf-ld
}

src_compile() {
	emake it || die
}

# make check is actually an install-check target, see bug #283177
src_test() { :; }

src_install() {
	dodoc ALIASES BLURB CHANGES FILES INSTALL README SYSDEPS TARGETS
	dodoc THANKS TODO VERSION
	doman *.1

	insopts -o root -g qmail -m 755
	insinto /var/qmail/bin
	doins fastforward newaliases newinclude printforward printmaillist \
		setforward setmaillist
}
