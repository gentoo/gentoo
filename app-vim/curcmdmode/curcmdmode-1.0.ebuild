# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit vim-plugin

DESCRIPTION="vim plugin: library for extending vim's mode() function"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=745"
LICENSE="GPL-2"
KEYWORDS="alpha ~amd64 ia64 ~mips ppc sparc x86"
IUSE=""

RDEPEND=">=app-vim/genutils-1.7"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides library functions and is not intended to be used
directly by the user."
