# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Displays a binary clock in your terminal"
HOMEPAGE="http://www.ngolde.de/binclock/"
SRC_URI="http://www.ngolde.de/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~ia64 ~mips ppc ppc64 sparc x86"

PATCHES=( "${FILESDIR}"/${P}-Makefile.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin src/binclock
	doman doc/binclock.1
	dodoc CHANGELOG README binclockrc
}
