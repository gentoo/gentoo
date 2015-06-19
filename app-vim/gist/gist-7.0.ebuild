# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/gist/gist-7.0.ebuild,v 1.1 2012/10/01 09:35:36 radhermit Exp $

EAPI=4

inherit vim-plugin

DESCRIPTION="vim plugin: interact with gists (gist.github.com)"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2423"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-vim/webapi
	net-misc/curl
	dev-vcs/git"

VIM_PLUGIN_HELPFILES="Gist.vim"
