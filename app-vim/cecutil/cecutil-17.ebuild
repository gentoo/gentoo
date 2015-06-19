# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/cecutil/cecutil-17.ebuild,v 1.5 2011/01/07 22:13:27 ranger Exp $

VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin

DESCRIPTION="vim plugin: library used by many of Charles Campbell's plugins"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1066"
LICENSE="vim"
KEYWORDS="alpha amd64 ia64 ~mips ppc sparc x86"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
"This plugin provides library functions and is not intended to be used
directly by the user. Documentation is available via ':help cecutil.txt'."
