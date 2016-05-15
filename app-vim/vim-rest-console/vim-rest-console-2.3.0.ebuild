# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: a REST console for vim"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=5182 https://github.com/diepm/vim-rest-console"
SRC_URI="https://github.com/diepm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

RDEPEND="net-misc/curl"

src_prepare() {
	rm *.md *.json *.rest || die
}
