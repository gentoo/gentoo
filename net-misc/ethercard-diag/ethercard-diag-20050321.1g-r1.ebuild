# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="low level mii diagnostic tools including mii-diag and etherwake (merge of netdiag/isa-diag)"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!sys-apps/nictools"

src_prepare() {
	default
	# Since the binary is `ether-wake`, make sure the man page is
	# `man ether-wake` and not `man etherwake`. #439504
	sed -i \
		-e 's/ETHERWAKE/ETHER-WAKE/' \
		-e 's/etherwake/ether-wake/' \
		pub/diag/{etherwake.8,Makefile} patches/* || die
	mv pub/diag/ether{,-}wake.8 || die
}

src_compile() {
	tc-export CC AR
	default
}
