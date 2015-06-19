# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/bash-support/bash-support-3.12.ebuild,v 1.3 2013/11/30 13:10:05 johu Exp $

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: Bash-IDE - Write and run bash scripts using menus and hotkeys"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=365"
LICENSE="public-domain"
KEYWORDS="amd64 x86"
IUSE=""

VIM_PLUGIN_HELPFILES="${PN}"

src_install() {
	dodoc ${PN}/doc/{ChangeLog,bash-hot-keys.pdf}
	rm -rf ${PN}/doc

	vim-plugin_src_install
}
