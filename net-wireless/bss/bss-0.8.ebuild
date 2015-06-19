# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bss/bss-0.8.ebuild,v 1.3 2010/06/11 11:00:39 ssuominen Exp $

EAPI=2
inherit toolchain-funcs

DESCRIPTION="Bluetooth stack smasher / fuzzer"
HOMEPAGE="http://securitech.homeunix.org/blue/"
SRC_URI="http://securitech.homeunix.org/blue/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="net-wireless/bluez"

src_prepare() {
	sed -i -e 's:/local::' Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		BSS_FLAGS="${LDFLAGS}" || die
}

src_install() {
	dosbin bss || die
	dodoc AUTHOR BUGS CHANGELOG CONTRIB NOTES README TODO \
		replay_packet/replay_l2cap_packet.c
}
