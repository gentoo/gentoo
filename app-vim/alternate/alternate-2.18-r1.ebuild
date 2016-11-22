# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin eutils

DESCRIPTION="vim plugin: quickly switch between .c and .h files"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=31"

LICENSE="alternate"
KEYWORDS="alpha amd64 ia64 ~mips ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
"This plugin provides a new :A command which will switch between a .c
file and the associated .h file. There is also :AS to split windows and
:AV to split windows vertiically."

PATCHES=(
	"${FILESDIR}"/${P}-hh-cc-alternation.patch
)

src_prepare() {
	default
}
