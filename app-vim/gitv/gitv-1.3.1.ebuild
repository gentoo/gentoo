# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gregsexton/gitv.git"
else
	SRC_URI="https://github.com/gregsexton/gitv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86 ~ppc-macos"
fi

DESCRIPTION="vim plugin: gitk for vim"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=3574 https://github.com/gregsexton/gitv/"
LICENSE="vim"

VIM_PLUGIN_HELPFILES="gitv"

RDEPEND="
	dev-vcs/git
	app-vim/fugitive"

src_prepare() {
	rm -f doc/tags || die
	rm -r img || die
	default
}
