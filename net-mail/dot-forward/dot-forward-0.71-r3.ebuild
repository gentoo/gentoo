# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/dot-forward/dot-forward-0.71-r3.ebuild,v 1.10 2012/12/22 16:48:53 ulm Exp $

inherit eutils fixheadtails qmail

DESCRIPTION="reads sendmail's .forward files under qmail"
HOMEPAGE="http://cr.yp.to/dot-forward.html"
SRC_URI="http://cr.yp.to/software/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

# See bug 97850
RESTRICT="test"

DEPEND=""
RDEPEND=""

pkg_setup() {
	qmail_create_groups
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PV}-errno.patch

	ht_fix_file Makefile

	qmail_set_cc
}

src_compile() {
	emake prog || die
}

src_install() {
	dodoc BLURB CHANGES FILES INSTALL README SYSDEPS TARGETS THANKS
	dodoc TODO VERSION
	doman *.1

	insopts -o root -g qmail -m 755
	insinto "${QMAIL_HOME}"/bin
	doins dot-forward || die
}
