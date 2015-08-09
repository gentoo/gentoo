# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit vim-plugin

DESCRIPTION="vim plugin: a color tool for vim"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3597"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="${PN}.txt"

RDEPEND="
	|| (
		app-editors/vim[python]
		( app-editors/gvim[python] dev-python/pygtk:2 )
	)"

src_prepare() {
	# use python colorpicker instead of C-based picker
	rm autoload/colorv/{colorpicker.c,Makefile} || die
}
