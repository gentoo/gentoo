# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: XQuery syntax highlighting"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=803"

LICENSE="vim.org"
KEYWORDS="alpha amd64 ia64 mips ppc ppc64 sparc x86"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for XQuery files."

src_prepare() {
	default
	# use hi def link. Bug #101788, bug #101804.
	sed -i -e 's,^hi\(ghlight\)\? link,hi def link,' syntax/xquery.vim \
		|| die "sed failed"
}
