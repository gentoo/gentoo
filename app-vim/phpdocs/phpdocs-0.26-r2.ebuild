# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: PHPDoc Support in VIM"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=520"

LICENSE="vim"
KEYWORDS="amd64 ppc ~sparc x86"

VIM_PLUGIN_HELPURI="https://www.vim.org/scripts/script.php?script_id=520"

src_prepare() {
	default
	sed -i 's/\r$//' "${S}"/plugin/phpdoc.vim || die "sed failed"
}
