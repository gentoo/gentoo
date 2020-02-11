# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: BNF file syntax highlighting"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=250"
LICENSE="vim.org"
KEYWORDS="~alpha amd64 ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for BNF files."

src_prepare() {
	default
	# fix hi link to use def, bug #101790.
	sed -i -e 's,hi link,hi def link,g' syntax/bnf.vim || die "sed failed"
}
