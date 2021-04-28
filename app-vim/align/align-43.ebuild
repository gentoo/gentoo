# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

DESCRIPTION="vim plugin: commands and maps to help produce aligned text"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=294"
LICENSE="vim"
KEYWORDS="~alpha amd64 ~ia64 ~mips ppc sparc x86"

RDEPEND="app-vim/cecutil"

VIM_PLUGIN_HELPFILES="align"
