# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/sleuth/sleuth-1.0.ebuild,v 1.1 2013/01/13 18:41:05 radhermit Exp $

EAPI="5"

inherit vim-plugin

DESCRIPTION="vim plugin: heuristically set buffer options"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=4375 https://github.com/tpope/vim-sleuth"
LICENSE="vim"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="${PN}"
