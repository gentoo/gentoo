# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/vim-r/vim-r-0.9.9.4.ebuild,v 1.1 2013/09/26 04:05:36 radhermit Exp $

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: integrate vim with R"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2628"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/R
	|| ( app-vim/conque app-vim/screen )"

VIM_PLUGIN_HELPFILES="r-plugin.txt"
