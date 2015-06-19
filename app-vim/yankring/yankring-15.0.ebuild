# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/yankring/yankring-15.0.ebuild,v 1.1 2013/01/13 09:10:09 radhermit Exp $

EAPI="5"

inherit vim-plugin

DESCRIPTION="vim plugin: maintains a history of previous yanks and deletes"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1234"
LICENSE="vim"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="${PN}.txt"
