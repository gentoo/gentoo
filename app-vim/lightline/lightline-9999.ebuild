# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/itchyny/lightline.vim/"
else
	SRC_URI="https://github.com/itchyny/${PN}.vim/archive/master.zip -> ${P}.zip"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="vim plugin: A light and configurable statusline/tabline"
HOMEPAGE="https://github.com/itchyny/lightline.vim/"
LICENSE="vim.org"
VIM_PLUGIN_HELPFILES="${PN}"

src_compile() { :; }
