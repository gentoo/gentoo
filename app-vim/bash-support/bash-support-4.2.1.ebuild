# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

DESCRIPTION="vim plugin: write and run bash scripts using menus and hotkeys"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=365"
LICENSE="public-domain"
KEYWORDS="amd64 x86"

VIM_PLUGIN_HELPFILES="${PN}"

src_install() {
	dodoc ${PN}/doc/{ChangeLog,bash-hotkeys.pdf}
	rm -rf ${PN}/doc || die

	vim-plugin_src_install
}
