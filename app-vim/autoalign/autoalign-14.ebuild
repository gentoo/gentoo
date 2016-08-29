# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: automatically align bib, c, c++, tex and vim code"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=884"
LICENSE="vim"
KEYWORDS="alpha amd64 ia64 mips ppc sparc x86"
IUSE=""

if [[ ${PV} != 9999* ]] ; then
	SRC_URI="mirror://gentoo/${P}.tar.xz
		http://dev.gentoo.org/~chutzpah/vim/${P}.tar.xz"
fi

DEPEND="app-arch/xz-utils"
RDEPEND="
	>=app-vim/align-30
	>=app-vim/cecutil-4"

VIM_PLUGIN_HELPFILES="autoalign"
VIM_PLUGIN_MESSAGES="filetype"

src_prepare() {
	# Don't use the cecutil.vim included in the tarball, use the one
	# provided by app-vim/cecutil instead.
	rm plugin/cecutil.vim || die
}
