# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Quotes from Felix von Leitner (fefe)"
HOMEPAGE="https://fortune-mod-fvl.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/fortune-mod-fvl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="games-misc/fortune-mod"

src_install() {
	insinto /usr/share/fortune
	doins fvl fvl.dat
}
