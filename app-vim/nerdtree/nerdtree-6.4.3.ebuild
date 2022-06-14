# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/scrooloose/nerdtree.git"
	inherit git-r3
else
	SRC_URI="https://github.com/scrooloose/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86 ~x64-macos"
fi

DESCRIPTION="vim plugin: A tree explorer plugin for navigating the filesystem"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=1658 https://github.com/scrooloose/nerdtree"
LICENSE="WTFPL-2"

VIM_PLUGIN_HELPFILES="NERD_tree"

DOCS=( CHANGELOG.md README.markdown )
