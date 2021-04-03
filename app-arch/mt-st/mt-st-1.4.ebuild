# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="control magnetic tape drive operation"
HOMEPAGE="https://github.com/iustin/mt-st"
SRC_URI="https://github.com/iustin/mt-st/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

src_configure() {
	tc-export CC
}

src_install() {
	dosbin mt stinit
	doman mt.1 stinit.8
	dodoc README* stinit.def.examples
}
