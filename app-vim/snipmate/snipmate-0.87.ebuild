# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vim-plugin

MY_PN=vim-${PN}
MY_P=${MY_PN}-${PV}

DESCRIPTION="vim plugin: TextMate-style snippets"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2540 https://github.com/garbas/vim-snipmate"
SRC_URI="https://github.com/garbas/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${MY_P}

VIM_PLUGIN_HELPFILES="SnipMate"
VIM_PLUGIN_MESSAGES="filetype"

src_prepare() {
	rm addon-info.json || die
}
