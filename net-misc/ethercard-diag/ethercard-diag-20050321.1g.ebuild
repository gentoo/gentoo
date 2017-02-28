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

DEPEND="!sys-apps/nictools"

src_compile() {
	tc-export CC AR
	default
}

src_install() {
	default
	dodir /sbin
	mv "${ED%/}"/usr/sbin/{mii-diag,ether-wake} "${ED%/}"/sbin/ || die
}
