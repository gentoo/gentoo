# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: fold creation utility"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=158"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ia64 ~mips ppc sparc x86"
IUSE=""

RDEPEND=">=app-vim/genutils-2.0"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides a number of commands for working with folds:
\    :FoldNonMatching [pattern] [context]
\    :FoldShowLines   {lines} [context]
\    :FoldEndFolding"
