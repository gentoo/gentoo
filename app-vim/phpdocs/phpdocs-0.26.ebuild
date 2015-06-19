# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/phpdocs/phpdocs-0.26.ebuild,v 1.17 2009/12/17 10:47:46 fauli Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: PHPDoc Support in VIM"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=520"
LICENSE="vim"
KEYWORDS="alpha ~amd64 ia64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""
DEPEND="${DEPEND} >=sys-apps/sed-4"
RDEPEND="${DEPEND}"

VIM_PLUGIN_HELPURI="http://www.vim.org/scripts/script.php?script_id=520"

src_unpack() {
	unpack ${A}
	sed -i 's/\r$//' "${S}"/plugin/phpdoc.vim || die "sed failed"
}
