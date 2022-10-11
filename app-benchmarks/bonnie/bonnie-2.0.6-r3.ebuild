# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Performance Test of Filesystem I/O using standard C library calls"
HOMEPAGE="https://www.textuality.com/bonnie/"
SRC_URI="https://www.textuality.com/bonnie/bonnie.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"

LICENSE="bonnie"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~mips ppc ppc64 sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-includes.patch
	"${FILESDIR}"/${P}-man.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_compile() {
	tc-export CC
	append-cflags -std=gnu89 # old codebase, incompatible with c2x

	emake -f /dev/null Bonnie
}

src_install() {
	newbin Bonnie bonnie
	doman bonnie.1
	dodoc Instructions
}
