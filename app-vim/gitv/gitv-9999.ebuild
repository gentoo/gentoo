# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/gitv/gitv-9999.ebuild,v 1.1 2014/06/19 05:43:03 radhermit Exp $

EAPI=5
inherit vim-plugin

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/gregsexton/gitv.git"
else
	SRC_URI="https://github.com/gregsexton/gitv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~ppc-macos"
fi

DESCRIPTION="vim plugin: gitk for vim"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3574 https://github.com/gregsexton/gitv/ http://www.gregsexton.org/portfolio/gitv/"
LICENSE="vim"

VIM_PLUGIN_HELPFILES="gitv"

RDEPEND="dev-vcs/git
	app-vim/fugitive"
