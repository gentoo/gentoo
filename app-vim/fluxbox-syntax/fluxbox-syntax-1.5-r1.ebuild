# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: fluxbox files syntax and indent"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=679"
LICENSE="vim"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"

RDEPEND="app-vim/genindent"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting and indent settings for fluxbox
menus and similar files. Upstream don't provide us with an ftdetect file,
but a simple one has been created for you by this ebuild. You can manually
set the filetype using :set filetype=fluxbox if necessary."

VIM_PLUGIN_MESSAGES="filetype"

src_prepare() {
	default
	mkdir ftdetect || die
	echo "au BufNewFile,BufRead /*/*fluxbox/*menu set filetype=fluxbox" \
		> ftdetect/fluxbox.vim || die
}
