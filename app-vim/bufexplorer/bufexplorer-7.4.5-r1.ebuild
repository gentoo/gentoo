# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/bufexplorer/bufexplorer-7.4.5-r1.ebuild,v 1.1 2014/10/25 19:04:50 radhermit Exp $

EAPI=5

inherit vim-plugin eutils

DESCRIPTION="vim plugin: easily browse vim buffers"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=42"
LICENSE="bufexplorer.vim"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	edos2unix {doc,plugin}/* || die
}
