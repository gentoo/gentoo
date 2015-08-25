# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vim-plugin

MY_PN=gist-vim
MY_P=${MY_PN}-${PV}

DESCRIPTION="vim plugin: interact with gists (gist.github.com)"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2423 https://github.com/mattn/gist-vim"
SRC_URI="https://github.com/mattn/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~x64-macos"

RDEPEND="app-vim/webapi
	net-misc/curl
	dev-vcs/git"

VIM_PLUGIN_HELPFILES="Gist.vim"

S=${WORKDIR}/${MY_P}

src_prepare() {
	rm README.md gist.vim* Makefile || die
}
