# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit vim-plugin

MY_PN=LanguageTool
DESCRIPTION="grammar checker for various languages"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3223"
LICENSE="vim"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${MY_PN}"

RDEPEND="app-text/languagetool"

PATCHES=( "${FILESDIR}"/${P}-script.patch )
