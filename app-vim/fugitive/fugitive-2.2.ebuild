# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit vim-plugin

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/tpope/vim-fugitive.git"
else
	inherit vcs-snapshot
	SRC_URI="https://github.com/tpope/vim-fugitive/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86 ~ppc-macos ~x64-macos"
fi

DESCRIPTION="vim plugin: a git wrapper for vim"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2975 https://github.com/tpope/vim-fugitive/"
LICENSE="vim"

VIM_PLUGIN_HELPFILES="${PN}.txt"

RDEPEND="dev-vcs/git"
