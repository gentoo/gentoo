# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Command-line file splitter/joiner for Linux"
HOMEPAGE="http://lxsplit.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/lxsplit/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

src_compile() {
	tc-export CC
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	einstalldocs
	dobin "${PN}"
}
