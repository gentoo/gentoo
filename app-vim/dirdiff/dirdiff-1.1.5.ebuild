# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: diff and merge two directories recursively"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=102"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-apps/diffutils"

VIM_PLUGIN_HELPFILES="${PN}.txt"
