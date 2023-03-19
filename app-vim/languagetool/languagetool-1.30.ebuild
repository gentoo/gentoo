# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

MY_PN="LanguageTool"
DESCRIPTION="grammar checker for various languages"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=3223"

LICENSE="vim"
KEYWORDS="~amd64 ~arm64 ~x86"

VIM_PLUGIN_HELPFILES="${MY_PN}"

RDEPEND="app-text/languagetool"

PATCHES=( "${FILESDIR}"/${PN}-1.29-script.patch )
