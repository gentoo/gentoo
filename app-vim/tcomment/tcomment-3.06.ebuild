# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/tcomment/tcomment-3.06.ebuild,v 1.1 2015/03/06 23:03:00 radhermit Exp $

EAPI=5

inherit vim-plugin

MY_PN="tcomment_vim"
DESCRIPTION="vim plugin: an extensible and universal comment toggler"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1173 https://github.com/tomtom/tcomment_vim"
SRC_URI="https://github.com/tomtom/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare() {
	rm -r README spec addon* || die
}
