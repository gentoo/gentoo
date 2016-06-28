# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: PDV (phpDocumentor for Vim)"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1355"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

VIM_PLUGIN_HELPTEXT="To use this plugin, you should map the PhpDoc() function
to something. For example, add the following to your ~/.vimrc:

imap <C-o> ^[:set paste<CR>:exe PhpDoc()<CR>:set nopaste<CR>i

For more info, see:
${HOMEPAGE}"
