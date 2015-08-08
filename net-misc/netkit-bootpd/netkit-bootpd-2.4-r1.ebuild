# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit eutils toolchain-funcs

MY_P=${P/netkit-}

DESCRIPTION="Netkit - bootp"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netboot/"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netboot/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ppc ~sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
}

src_compile() {
	tc-export CC
	emake linux || die
}

src_install() {
	dosbin bootp{d,ef,gw,test} || die

	for x in d ef gw test; do
		dosym bootp${x} /usr/sbin/in.bootp${x} || die
	done

	doman *.5 *.8
	dodoc Announce Changes Problems README{,-linux} ToDo
}
