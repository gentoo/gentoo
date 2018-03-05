# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: ansi escape sequences concealed, but highlighted as specified"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=302"
LICENSE="public-domain"
KEYWORDS="amd64 x86"

RDEPEND="app-vim/cecutil"

VIM_PLUGIN_HELPFILES="AnsiEsc.txt"
