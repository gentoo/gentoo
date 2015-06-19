# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/cryptcat/cryptcat-1.2.1-r1.ebuild,v 1.5 2012/07/29 17:24:22 armin76 Exp $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="netcat clone extended with twofish encryption"
HOMEPAGE="http://farm9.org/Cryptcat/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-unix-${PV}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

S=${WORKDIR}/unix

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	echo "#define arm arm_timer" >> generic.h
	sed -i \
		-e 's:#define HAVE_BIND:#undef HAVE_BIND:' \
		-e '/^#define FD_SETSIZE 16/s:16:1024:' \
		-e 's:\<LINUX\>:__linux__:' \
		netcat.c generic.h
	tc-export CC CXX
}

src_install() {
	dobin cryptcat
	dodoc Changelog README README.cryptcat netcat.blurb
}
