# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

DESCRIPTION="vim plugin: sets vim breakpoints visually"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=618"
SRC_URI="https://www.vim.org/scripts/download_script.php?src_id=8142 -> ${P}.zip"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~sparc ~x86"

S="${WORKDIR}"

RDEPEND="
	|| ( >=app-editors/vim-7.0 >=app-editors/gvim-7.0 )
	>=app-vim/multvals-3.6.1
	>=app-vim/genutils-1.13
	>=app-vim/foldutil-1.6"
BDEPEND="app-arch/unzip"

VIM_PLUGIN_HELPTEXT=\
"This plugin allows breakpoints to be set and cleared visually. To start,
use :BreakPts, move to the required function and press <CR>. Breakpoints
can then be added using :BPToggle or <F9>."
