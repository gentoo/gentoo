# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=${PN/mod-/}
DESCRIPTION="set of fortunes based on the Tao-Teh-Ching"
HOMEPAGE="http://fortunes.quotationsbook.com/fortunes/collection/67/TAO"
SRC_URI="mirror://gentoo/${MY_PN}.tar.gz"
S="${WORKDIR}"/${MY_PN}

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="games-misc/fortune-mod
	!>=games-misc/fortune-mod-3.6.1"

src_install() {
	insinto /usr/share/fortune
	doins tao tao.dat
}
