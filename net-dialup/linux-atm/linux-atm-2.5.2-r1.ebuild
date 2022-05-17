# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic linux-info

DESCRIPTION="Tools for ATM"
HOMEPAGE="http://linux-atm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="virtual/yacc"

RESTRICT="test"

CONFIG_CHECK="~ATM"

PATCHES=(
	"${FILESDIR}"/${P}-headers.patch
	"${FILESDIR}"/${P}-linux-5.2-SIOCGSTAMP.patch
)

src_prepare() {
	default

	sed -i '/#define _LINUX_NETDEVICE_H/d' \
		src/arpd/*.c || die "sed command on arpd/*.c files failed"

	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing
	econf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	dodoc doc/README* doc/atm*
}
