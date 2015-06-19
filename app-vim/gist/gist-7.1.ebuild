# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/gist/gist-7.1.ebuild,v 1.2 2013/10/21 11:55:33 grobian Exp $

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: interact with gists (gist.github.com)"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2423"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE=""

RDEPEND="app-vim/webapi
	net-misc/curl
	dev-vcs/git"

VIM_PLUGIN_HELPFILES="Gist.vim"
