# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/neocon/neocon-20110228.ebuild,v 1.2 2011/08/23 02:10:20 radhermit Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="A simple serial console utility that tries to open ttys repeatedly"
HOMEPAGE="http://wiki.openmoko.org/wiki/NeoCon"
SRC_URI="http://dev.gentoo.org/~radhermit/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" all
}

src_install() {
	dobin neocon
	dodoc README
}
