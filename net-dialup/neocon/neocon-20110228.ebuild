# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

DESCRIPTION="A simple serial console utility that tries to open ttys repeatedly"
HOMEPAGE="http://wiki.openmoko.org/wiki/NeoCon"
SRC_URI="https://dev.gentoo.org/~radhermit/distfiles/${P}.tar.bz2"

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
