# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="(Sun) Cobalt Qube/RaQ button reading and LCD writing utilities"
HOMEPAGE="https://people.debian.org/~pm/mips-cobalt/"
SRC_URI="https://people.debian.org/~pm/mips-cobalt/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~mips x86"

PATCHES=(
	"${FILESDIR}/${P}-include-stdlib.h-for-exit.patch"
	"${FILESDIR}/${P}-makefile.patch"
)

src_prepare() {
	default

	tc-export CC
}
