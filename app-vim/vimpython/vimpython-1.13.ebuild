# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/vimpython/vimpython-1.13.ebuild,v 1.5 2011/01/07 22:49:21 ranger Exp $

VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin

DESCRIPTION="vim plugin: A set of menus/shortcuts to work with Python files"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=30"

LICENSE="vim"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

RDEPEND="${DEPEND}"

VIM_PLUGIN_HELPURI="${HOMEPAGE}"
