# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/gundo/gundo-2.2.2.ebuild,v 1.1 2011/07/30 20:16:14 radhermit Exp $

EAPI=4
VIM_PLUGIN_VIM_VERSION="7.3"

inherit vim-plugin

MY_PN="Gundo"
DESCRIPTION="vim plugin: visualize your Vim undo tree"
HOMEPAGE="http://sjl.bitbucket.org/gundo.vim/"
SRC_URI="https://github.com/vim-scripts/${MY_PN}/tarball/${PV} -> ${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( app-editors/vim[python] app-editors/gvim[python] )
	>=dev-lang/python-2.4"

VIM_PLUGIN_HELPFILES="gundo.txt"

src_unpack() {
	unpack ${A}
	mv *-${MY_PN}-* "${S}"
}

src_prepare() {
	rm -f README*
}
