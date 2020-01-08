# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: syntax highlighting for eruby"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=403"
LICENSE="vim.org"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"

VIM_PLUGIN_HELPTEXT="This plugin provides syntax highlighting for eruby"

src_prepare() {
	default
	sed -i -e 's#hi link#hi def link#' syntax/eruby.vim || die "sed failed"
}
