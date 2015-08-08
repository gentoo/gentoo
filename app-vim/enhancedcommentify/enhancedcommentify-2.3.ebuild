# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit vim-plugin eutils

DESCRIPTION="vim plugin: enhanced comment creation"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=23"

LICENSE="BSD"
KEYWORDS="alpha amd64 ia64 ~mips ppc sparc x86"
IUSE=""

VIM_PLUGIN_HELPFILES="EnhancedCommentify"

DEPEND="${DEPEND} >=sys-apps/sed-4"
# bug #74897
RDEPEND="!app-vim/ctx"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# gentooy things, bug #79185
	epatch "${FILESDIR}"/${PN}-2.1-gentooisms.patch
	epatch "${FILESDIR}"/${PN}-2.1-extra-ft-support.patch
}
