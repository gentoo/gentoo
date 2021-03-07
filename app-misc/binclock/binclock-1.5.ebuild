# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Displays a binary clock in your terminal"
HOMEPAGE="http://www.ngolde.de/binclock/"
SRC_URI="http://www.ngolde.de/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND=""
DEPEND=">=sys-apps/sed-4"

PATCHES=( "${FILESDIR}/binclock-1.5-Makefile.patch" )

src_configure() {
	append-cflags -Wall -pedantic
	tc-export CC
}

src_install() {
	dobin binclock
	doman doc/binclock.1
	dodoc CHANGELOG README binclockrc
}
