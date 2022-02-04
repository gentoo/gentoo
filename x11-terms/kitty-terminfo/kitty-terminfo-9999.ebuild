# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Terminfo for kitty, a GPU-based terminal emulator"
HOMEPAGE="https://sw.kovidgoyal.net/kitty/"
EGIT_REPO_URI="https://github.com/kovidgoyal/kitty.git"

LICENSE="GPL-3"
SLOT="0"
RESTRICT="test" # intended to be ran on the full kitty package

BDEPEND="sys-libs/ncurses"

src_compile() { :; }

src_install() {
	dodir /usr/share/terminfo
	tic -xo "${ED}"/usr/share/terminfo terminfo/kitty.terminfo || die
}
