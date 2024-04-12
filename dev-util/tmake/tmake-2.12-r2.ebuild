# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Cross platform Makefile tool"
SRC_URI="https://downloads.sourceforge.net/tmake/${P}.tar.bz2"
HOMEPAGE="http://tmake.sourceforge.net"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND=">=dev-lang/perl-5"

src_install() {
	dobin bin/tmake bin/progen
	dodir /usr/lib/tmake
	cp -pPRf "${S}"/lib/* "${ED}"/usr/lib/tmake
	dodoc -r README doc/*
	echo "TMAKEPATH=\"${EPREFIX}/usr/lib/tmake/linux-g++\"" > "${T}"/51tmake
	doenvd "${T}"/51tmake
}
