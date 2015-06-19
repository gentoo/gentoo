# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/vim-misc/vim-misc-1.17.6.ebuild,v 1.1 2015/06/19 06:15:48 radhermit Exp $

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: miscellaneous auto-load scripts"
HOMEPAGE="http://peterodding.com/code/vim/misc/"
SRC_URI="https://github.com/xolox/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="misc.txt"

src_prepare() {
	rm INSTALL.md addon-info.json autoload/xolox/misc/echo.exe || die
}
