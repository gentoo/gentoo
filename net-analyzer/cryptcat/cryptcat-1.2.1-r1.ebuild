# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
