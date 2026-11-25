# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kovidgoyal/kitty.git"
else
	SRC_URI="https://github.com/kovidgoyal/kitty/releases/download/v${PV}/kitty-${PV}.tar.xz"
	S=${WORKDIR}/kitty-${PV}
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

DESCRIPTION="Terminfo for kitty, a GPU-based terminal emulator"
HOMEPAGE="https://sw.kovidgoyal.net/kitty/"

LICENSE="GPL-3"
SLOT="0"
RESTRICT="test" # intended to be ran on the full kitty package

BDEPEND="sys-libs/ncurses"

src_compile() { :; }

src_install() {
	dodir /usr/share/terminfo
	tic -xo "${ED}"/usr/share/terminfo terminfo/kitty.terminfo || die
}
