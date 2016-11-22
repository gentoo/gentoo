# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: pushd / popd from the vim commandline"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=129"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ia64 mips ppc sparc x86"
IUSE=""

RDEPEND="
	>=app-vim/genutils-1.1
	>=app-vim/cmdalias-1.0"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides :Pushd and :Popd commands which emulate bash's pushd
and popd functions."
