# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/tmake/tmake-2.12.ebuild,v 1.12 2013/01/14 21:45:41 ulm Exp $

EAPI="3"

DESCRIPTION="A Cross platform Makefile tool"
SRC_URI="mirror://sourceforge/tmake/${P}.tar.bz2"
HOMEPAGE="http://tmake.sourceforge.net"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ppc x86 ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND=">=dev-lang/perl-5"

src_install () {
	dobin bin/tmake bin/progen
	dodir /usr/lib/tmake
	cp -pPRf "${S}"/lib/* "${ED}"/usr/lib/tmake
	dodoc README
	dohtml -r doc/*
	echo "TMAKEPATH=\"${EPREFIX}/usr/lib/tmake/linux-g++\"" > "${T}"/51tmake
	doenvd "${T}"/51tmake
}
