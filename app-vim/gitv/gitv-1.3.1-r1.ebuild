# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: gitk for vim"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=3574 https://github.com/gregsexton/gitv/"
SRC_URI="https://github.com/gregsexton/gitv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="vim"
KEYWORDS="amd64 x86"

VIM_PLUGIN_HELPFILES="gitv"

RDEPEND="
	dev-vcs/git
	app-vim/fugitive"

src_prepare() {
	rm -f doc/tags || die
	rm -r img || die
	default
}
