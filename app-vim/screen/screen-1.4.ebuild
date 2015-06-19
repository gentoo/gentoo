# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/screen/screen-1.4.ebuild,v 1.1 2011/04/29 00:20:24 radhermit Exp $

EAPI="3"

inherit vim-plugin

DESCRIPTION="vim plugin: simulate a split shell with screen or tmux"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2711"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="screen.txt"

RDEPEND="|| ( app-misc/screen app-misc/tmux )"
