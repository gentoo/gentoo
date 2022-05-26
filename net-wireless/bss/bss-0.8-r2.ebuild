# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Bluetooth stack smasher / fuzzer"
HOMEPAGE="http://securitech.homeunix.org/blue/"
SRC_URI="http://securitech.homeunix.org/blue/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="net-wireless/bluez"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dosbin bss
	dodoc AUTHOR BUGS CHANGELOG CONTRIB NOTES README TODO \
		replay_packet/replay_l2cap_packet.c
}
