# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

DESCRIPTION="vim plugin: A tree explorer plugin for navigating the filesystem"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=1658 https://github.com/scrooloose/nerdtree"
SRC_URI="https://github.com/scrooloose/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="WTFPL-2"
KEYWORDS="~amd64 ~x86 ~x64-macos"

VIM_PLUGIN_HELPFILES="NERD_tree"

src_prepare() {
	default
	rm LICENCE || die
}
