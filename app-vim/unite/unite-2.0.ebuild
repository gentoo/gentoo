# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/unite/unite-2.0.ebuild,v 1.1 2011/05/22 03:09:02 radhermit Exp $

EAPI=4

inherit vim-plugin

DESCRIPTION="vim plugin: unite all sources"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3396"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="unite.txt"

src_prepare() {
	# remove unused tests
	rm -rf test
}
