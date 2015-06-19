# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/screen/screen-1.5.ebuild,v 1.1 2011/07/21 00:29:46 radhermit Exp $

EAPI="4"

inherit vim-plugin

MY_PN="Screen-vim---gnu-screentmux"
DESCRIPTION="vim plugin: simulate a split shell with screen or tmux"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2711"
SRC_URI="https://github.com/vim-scripts/${MY_PN}/tarball/${PV} -> ${P}.tar.gz"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="screen.txt"

RDEPEND="|| ( app-misc/screen app-misc/tmux )"

src_unpack() {
	unpack ${A}
	mv *-${MY_PN}-* "${S}"
}

src_prepare() {
	rm README || die
}
