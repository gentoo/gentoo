# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

MY_PN=vim-${PN}
MY_P=${MY_PN}-${PV}

DESCRIPTION="vim script: fugitive extension to manage and merge git branches"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=4955 https://github.com/idanarye/vim-merginal/"
SRC_URI="https://github.com/idanarye/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="vim"
KEYWORDS="amd64 x86"

RDEPEND="app-vim/fugitive"

VIM_PLUGIN_HELPFILES="${PN}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	rm README.md || die
	default
}
