# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/c-support/c-support-6.0.ebuild,v 1.3 2013/11/30 13:11:03 johu Exp $

EAPI="5"

inherit vim-plugin

DESCRIPTION="vim plugin: C/C++-IDE -- Write and run programs using menus and hotkeys"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=213"
LICENSE="public-domain"
KEYWORDS="amd64 x86"
IUSE=""

VIM_PLUGIN_HELPFILES="${PN}"

src_install() {
	dodoc ${PN}/doc/{ChangeLog,c-hotkeys.pdf}
	rm -r ${PN}/doc || die

	vim-plugin_src_install
}
