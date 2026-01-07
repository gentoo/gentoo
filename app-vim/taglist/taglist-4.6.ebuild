# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

DESCRIPTION="vim plugin: ctags-based source code browser"
HOMEPAGE="https://vim-taglist.sourceforge.net/"

LICENSE="vim"
KEYWORDS="~alpha amd64 ~hppa ~mips ppc ~sparc x86"

RDEPEND="dev-util/ctags"

VIM_PLUGIN_HELPFILES="${PN}.txt"

PATCHES=(
	"${FILESDIR}"/${PN}-3.4-ebuilds.patch
)
