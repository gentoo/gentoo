# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit vim-plugin

MY_PN="ColorV"
DESCRIPTION="vim plugin: a color tool for vim"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3597"
SRC_URI="https://github.com/vim-scripts/${MY_PN}/tarball/${PV} -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="${PN}"

RDEPEND="
	|| (
		app-editors/vim[python]
		( app-editors/gvim[python] dev-python/pygtk:2 )
	)"

src_unpack() {
	unpack ${A}
	mv *-${MY_PN}-* "${S}"
}

src_prepare() {
	rm README* || die
}
