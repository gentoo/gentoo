# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/yankring/yankring-14.0.ebuild,v 1.1 2012/08/03 10:03:52 radhermit Exp $

EAPI="4"

inherit vim-plugin

DESCRIPTION="vim plugin: maintains a history of previous yanks and deletes"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1234"
LICENSE="vim"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="${PN}.txt"
