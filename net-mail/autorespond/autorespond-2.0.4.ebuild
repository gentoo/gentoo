# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/autorespond/autorespond-2.0.4.ebuild,v 1.15 2011/02/06 08:33:07 leio Exp $

inherit eutils

DEBIAN_PV="1"
DEBIAN_P="${P/-/_}-${DEBIAN_PV}"
DESCRIPTION="Autoresponder add on package for qmailadmin"
HOMEPAGE="http://inter7.com/devel/"
SRC_URI="mirror://sourceforge/qmailadmin/${P}.tar.gz
	mirror://debian/pool/contrib/${PN:0:1}/${PN}/${DEBIAN_P}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc s390 sh sparc x86"
IUSE=""

RDEPEND="virtual/qmail"
DEPEND=""

src_unpack() {
	unpack ${P}.tar.gz
	epatch "${DISTDIR}"/${DEBIAN_P}.diff.gz
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die
}

src_install () {
	into /var/qmail
	dobin autorespond || die "dobin failed"
	into /usr
	dodoc README help_message qmail-auto ChangeLog
	doman *.1
}
