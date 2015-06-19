# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/vimpress/vimpress-2.1.5.ebuild,v 1.3 2012/08/04 19:43:48 johu Exp $

EAPI=4

inherit vim-plugin

MY_PN="VimRepress"
DESCRIPTION="vim plugin: manage wordpress blogs from vim"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3510"
SRC_URI="https://github.com/vim-scripts/${MY_PN}/tarball/${PV} -> ${P}.tar.gz"
LICENSE="vim"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="|| ( app-editors/vim[python] app-editors/gvim[python] )
	|| ( dev-lang/python:2.7 dev-lang/python:2.6 )
	dev-python/markdown"

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_unpack() {
	unpack ${A}
	mv *-${MY_PN}-* "${S}"
}

src_prepare() {
	rm README || die
}
