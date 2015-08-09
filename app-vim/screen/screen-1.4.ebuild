# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit vim-plugin

DESCRIPTION="vim plugin: simulate a split shell with screen or tmux"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2711"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="screen.txt"

RDEPEND="|| ( app-misc/screen app-misc/tmux )"
