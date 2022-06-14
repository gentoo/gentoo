# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

DESCRIPTION="vim plugin: write and run bash scripts using menus and hotkeys"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=365"
SRC_URI="https://www.vim.org/scripts/download_script.php?src_id=24452 -> ${P}.zip"
S="${WORKDIR}"/${PN}

LICENSE="public-domain"
KEYWORDS="amd64 x86"

BDEPEND="app-arch/unzip"

VIM_PLUGIN_HELPFILES="${PN}"

src_install() {
	dodoc doc/{ChangeLog,bash-hotkeys.pdf}
	rm -rf ${PN}/doc || die

	vim-plugin_src_install
}
