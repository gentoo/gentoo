# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit vim-plugin

DESCRIPTION="vim plugin: allows multiple highlighted searches"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=479"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=9276 -> ${P}.zip"
LICENSE="vim"
KEYWORDS="alpha amd64 ia64 ~mips ppc sparc x86"
IUSE=""

VIM_PLUGIN_HELPFILES="MultipleSearch"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"
