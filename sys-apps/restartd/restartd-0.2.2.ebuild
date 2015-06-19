# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/restartd/restartd-0.2.2.ebuild,v 1.1 2010/12/31 18:15:53 jer Exp $

EAPI="2"

inherit eutils toolchain-funcs

MY_PV=${PV/_alpha/.a-}
DESCRIPTION="A daemon for checking your running and not running processes"
HOMEPAGE="http://packages.debian.org/unstable/utils/restartd"
SRC_URI="mirror://debian/pool/main/r/restartd/${PN}_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_prepare() {
	sed -i Makefile -e 's|-o restartd|$(LDFLAGS) &|g' || die "sed Makefile"
}

src_compile() {
	emake CC=$(tc-getCC) C_ARGS="${CFLAGS}" || die
}

src_install() {
	dodir /etc /usr/sbin /usr/share/man/man8 /usr/share/man/fr/man8/
	emake DESTDIR="${D}" install || die
}
