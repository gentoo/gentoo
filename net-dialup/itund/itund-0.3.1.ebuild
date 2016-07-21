# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="ItunD (ISDN tunnel Daemon) provides a network tunnel over ISDN lines using CAPI"
HOMEPAGE="http://www.melware.org/ISDN_Tunnel_Daemon"
SRC_URI="ftp://ftp.melware.net/itund/${P}.tgz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""
DEPEND="sys-libs/zlib
	net-dialup/capi4k-utils"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# patch Makefile to use our CFLAGS
	sed -i -e "s:^\(CFLAGS=.*\) -O2 :\1 ${CFLAGS} :g" Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dosbin itund
	dodoc CHANGES README
}
