# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/vim-misc/vim-misc-1.17.1.ebuild,v 1.3 2015/06/16 10:50:16 zlogene Exp $

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: miscellaneous auto-load scripts"
HOMEPAGE="http://peterodding.com/code/vim/misc/"
SRC_URI="https://github.com/xolox/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="amd64 x86"

RDEPEND="!app-vim/xolox-misc"

VIM_PLUGIN_HELPFILES="misc.txt"

src_prepare() {
	rm addon-info.json autoload/xolox/misc/echo.exe || die
}
