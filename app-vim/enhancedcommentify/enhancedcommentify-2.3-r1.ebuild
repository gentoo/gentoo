# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: enhanced comment creation"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=23"

LICENSE="BSD"
KEYWORDS="~alpha amd64 ~ia64 ~mips ppc sparc x86"

VIM_PLUGIN_HELPFILES="EnhancedCommentify"

DEPEND="sys-apps/sed"

# See bug #74897.
RDEPEND="
	${DEPEND}
	!app-vim/ctx"

PATCHES=(
	# See bug #79185.
	"${FILESDIR}"/${PN}-2.1-gentooisms.patch
	"${FILESDIR}"/${PN}-2.1-extra-ft-support.patch
)
