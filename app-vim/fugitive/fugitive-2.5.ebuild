# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit vim-plugin

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tpope/vim-fugitive.git"
else
	SRC_URI="https://github.com/tpope/vim-fugitive/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-macos"
	S="${WORKDIR}/vim-${P}"
fi

DESCRIPTION="vim plugin: a git wrapper for vim"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=2975 https://github.com/tpope/vim-fugitive/"
LICENSE="vim"

VIM_PLUGIN_HELPFILES="${PN}.txt"

RDEPEND="dev-vcs/git"
