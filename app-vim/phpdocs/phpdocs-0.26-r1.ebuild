# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: PHPDoc Support in VIM"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=520"
LICENSE="vim"
KEYWORDS="amd64 ~ia64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

VIM_PLUGIN_HELPURI="https://www.vim.org/scripts/script.php?script_id=520"

src_prepare() {
	default
	sed -i 's/\r$//' "${S}"/plugin/phpdoc.vim || die "sed failed"
}
