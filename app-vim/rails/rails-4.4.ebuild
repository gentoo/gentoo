# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/rails/rails-4.4.ebuild,v 1.1 2011/11/07 21:19:18 radhermit Exp $

EAPI=4

inherit vim-plugin

MY_PN="rails.vim"
DESCRIPTION="vim plugin: aids developing Ruby on Rails applications"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1567"
SRC_URI="https://github.com/vim-scripts/${MY_PN}/tarball/${PV} -> ${P}.tar.gz"
LICENSE="vim"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_unpack() {
	unpack ${A}
	mv *-${MY_PN}-* "${S}"
}

src_prepare() {
	rm README || die
}
