# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/dirdiff/dirdiff-1.1.5.ebuild,v 1.1 2015/02/06 18:47:15 radhermit Exp $

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: diff and merge two directories recursively"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=102"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-apps/diffutils"

VIM_PLUGIN_HELPFILES="${PN}.txt"
