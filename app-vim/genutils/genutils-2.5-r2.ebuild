# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: library with various useful functions"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=197"
SRC_URI="https://www.vim.org/scripts/download_script.php?src_id=11399 -> ${P}.zip"
S="${WORKDIR}"

LICENSE="GPL-3"
KEYWORDS="~alpha amd64 ~ia64 ~mips ppc sparc x86"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides library functions and is not intended to be used
directly by the user."

DEPEND="app-arch/unzip"
