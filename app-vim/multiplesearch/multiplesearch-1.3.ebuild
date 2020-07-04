# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: allows multiple highlighted searches"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=479"
SRC_URI="https://www.vim.org/scripts/download_script.php?src_id=9276 -> ${P}.zip"
LICENSE="vim"
KEYWORDS="~alpha amd64 ~ia64 ~mips ppc sparc x86"

VIM_PLUGIN_HELPFILES="MultipleSearch.txt"

DEPEND="app-arch/unzip"

S=${WORKDIR}
