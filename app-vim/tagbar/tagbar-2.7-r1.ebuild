# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: display tags of the current file ordered by scope"
HOMEPAGE="
	https://github.com/preservim/tagbar
	https://www.vim.org/scripts/script.php?script_id=3465
"
SRC_URI="https://github.com/preservim/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="vim"
KEYWORDS="amd64 x86"

RDEPEND=">=dev-util/ctags-5.5"

VIM_PLUGIN_HELPFILES="${PN}.txt"
