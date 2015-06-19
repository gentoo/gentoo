# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/gitv/gitv-1.2.ebuild,v 1.2 2015/03/20 19:30:58 radhermit Exp $

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: gitk for vim"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3574"
SRC_URI="https://github.com/gregsexton/gitv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="vim"
KEYWORDS="amd64 x86 ~ppc-macos"

VIM_PLUGIN_HELPFILES="gitv"

RDEPEND="dev-vcs/git
	app-vim/fugitive"
