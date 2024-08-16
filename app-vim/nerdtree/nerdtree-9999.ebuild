# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/preservim/nerdtree.git"
	inherit git-r3
else
	SRC_URI="https://github.com/preservim/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~x64-macos"
fi

DESCRIPTION="vim plugin: A tree explorer plugin for navigating the filesystem"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=1658 https://github.com/preservim/nerdtree"
LICENSE="WTFPL-2"

VIM_PLUGIN_HELPFILES="NERD_tree"

DOCS=( CHANGELOG.md README.markdown )
