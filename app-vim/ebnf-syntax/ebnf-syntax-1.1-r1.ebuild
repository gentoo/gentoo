# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit vim-plugin

DESCRIPTION="vim plugin: EBNF (ISO/IEC 14997) file syntax highlighting"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=545"
LICENSE="vim"
KEYWORDS="alpha amd64 ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for EBNF (ISO/IEC 14997) files."

src_unpack() {
	unpack ${A}
	cd "${S}"
	# don't use hi link, bug #101799.
	sed -i -e 's,hi link,hi def link,' syntax/ebnf.vim || die "sed failed"
}
