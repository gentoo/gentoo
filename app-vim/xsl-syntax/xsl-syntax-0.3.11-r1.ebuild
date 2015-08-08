# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit vim-plugin

DESCRIPTION="vim plugin: Syntax for XSLT (with HTML and others)"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=257"
LICENSE="vim"
KEYWORDS="alpha amd64 ia64 ~mips ppc ppc64 sparc x86"
IUSE=""
VIM_PLUGIN_HELPURI="http://www.vim.org/scripts/script.php?script_id=257"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# hi link is evil. See bug #101787, bug #101804.
	sed -i -e 's,^hi link,hi def link,' syntax/xsl.vim || die "sed failed"
}
