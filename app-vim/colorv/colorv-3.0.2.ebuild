# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/colorv/colorv-3.0.2.ebuild,v 1.1 2013/01/13 08:58:40 radhermit Exp $

EAPI="5"

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
