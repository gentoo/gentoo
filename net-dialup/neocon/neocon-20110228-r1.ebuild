# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Simple serial console utility that tries to open ttys repeatedly"
HOMEPAGE="https://wiki.openmoko.org/wiki/NeoCon"
SRC_URI="https://dev.gentoo.org/~radhermit/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" all
}

src_install() {
	dobin neocon
	dodoc README
}
