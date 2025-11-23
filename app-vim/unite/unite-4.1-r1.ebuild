# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: unite all sources"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=3396"

LICENSE="MIT"
KEYWORDS="amd64 x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

RDEPEND="!app-vim/neocomplcache"
