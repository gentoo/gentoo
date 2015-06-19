# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/fluxbox-syntax/fluxbox-syntax-1.5.ebuild,v 1.20 2013/06/12 22:04:54 radhermit Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: fluxbox files syntax and indent"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=679"
LICENSE="vim"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND="${RDEPEND} >=app-vim/genindent-1.0"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting and indent settings for fluxbox
menus and similar files. Upstream don't provide us with an ftdetect file,
but a simple one has been created for you by this ebuild. You can manually
set the filetype using :set filetype=fluxbox if necessary."

VIM_PLUGIN_MESSAGES="filetype"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# no ftdetect file provided. lame...
	mkdir ftdetect
	echo "au BufNewFile,BufRead /*/*fluxbox/*menu set filetype=fluxbox" \
		> ftdetect/fluxbox.vim
}
