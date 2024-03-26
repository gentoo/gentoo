# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: display current scope context in a C file"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=208"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~ia64 ppc x86"

VIM_PLUGIN_HELPURI="https://www.vim.org/scripts/script.php?script_id=208"

# bug #74897
RDEPEND="!app-vim/enhancedcommentify"

# See bug 591068.
DEPEND="app-editors/vim[perl]"
