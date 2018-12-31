# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: diff and merge two directories recursively"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=102"
LICENSE="BSD"
KEYWORDS="amd64 x86"

RDEPEND="sys-apps/diffutils"

VIM_PLUGIN_HELPFILES="${PN}.txt"
