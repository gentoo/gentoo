# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: interface with grep, find and id-utils"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1062"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE=""

VIM_PLUGIN_HELPURI="${HOMEPAGE}"

DEPEND=""
RDEPEND="
	${DEPEND}
	>=app-vim/genutils-1.18
	>=app-vim/multvals-3.6.1
	>=app-vim/cmdalias-1.0"

src_compile() {
	default
}
