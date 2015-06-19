# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/vim-misc/vim-misc-1.13.1.ebuild,v 1.1 2014/07/01 07:28:29 radhermit Exp $

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: miscellaneous auto-load scripts"
HOMEPAGE="http://peterodding.com/code/vim/misc/"
SRC_URI="https://github.com/xolox/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

RDEPEND="!app-vim/xolox-misc"

VIM_PLUGIN_HELPFILES="misc.txt"

src_prepare() {
	rm addon-info.json autoload/xolox/misc/echo.exe || die
}
