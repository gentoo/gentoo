# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/lxsplit/lxsplit-0.2.4.ebuild,v 1.5 2011/01/11 15:27:19 phajdan.jr Exp $

inherit toolchain-funcs

DESCRIPTION="Command-line file splitter/joiner for Linux"
HOMEPAGE="http://lxsplit.sourceforge.net"
SRC_URI="mirror://sourceforge/lxsplit/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

src_compile() {
	tc-export CC
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	dobin lxsplit || die
	dodoc ChangeLog README || die
}
