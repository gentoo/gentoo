# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/md4sum/md4sum-0.02.03.ebuild,v 1.6 2009/07/13 12:28:29 flameeyes Exp $

inherit eutils

DESCRIPTION="md4 and edonkey hash algorithm tool"
HOMEPAGE="http://absinth.dyndns.org/linux/c/"
SRC_URI="http://absinth.dyndns.org/linux/c/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

src_compile() {
	econf || die "econf failed"
	sed -i -e "s:CFLAGS=:CFLAGS=${CFLAGS} :g" \
		-e "s:install -s:install:g" Makefile
	emake LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	mkdir -p "${D}/usr/bin"
	mkdir -p "${D}/usr/share/man/man1"
	einstall || die "einstall failed"
}
