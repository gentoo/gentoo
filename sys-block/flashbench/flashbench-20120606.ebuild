# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Tool for benchmarking and classifying flash memory drives"
HOMEPAGE="https://git.linaro.org/people/arnd.bergmann/flashbench.git"
SRC_URI="https://dev.gentoo.org/~bircoph/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

PATCHES=( "${FILESDIR}"/${P}-Makefile.patch )

src_compile(){
	tc-export CC
	default
}

src_install() {
	dobin "${PN}"
	newbin erase "${PN}-erase" # erase is too ambiguous.
	dodoc README
}
