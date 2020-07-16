# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Quick and dirty mass SNMP scanner"
HOMEPAGE="http://s-tech.elsat.net.pl/braa/"
SRC_URI="http://s-tech.elsat.net.pl/braa/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8-gentoo.diff
)

src_prepare() {
	default
	sed -i braa.c -e 's|0.81|0.82|g' || die
	tc-export CC
}

src_install() {
	dobin braa
	dodoc README
}
