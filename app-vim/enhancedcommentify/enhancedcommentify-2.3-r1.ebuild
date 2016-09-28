# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin eutils

DESCRIPTION="vim plugin: enhanced comment creation"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=23"

LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="EnhancedCommentify"

DEPEND="
	>=sys-apps/sed-4"

# See bug #74897.
RDEPEND="
	${DEPEND}
	!app-vim/ctx"

src_prepare() {
	default

	# See bug #79185.
	epatch "${FILESDIR}"/${PN}-2.1-gentooisms.patch
	epatch "${FILESDIR}"/${PN}-2.1-extra-ft-support.patch
}
