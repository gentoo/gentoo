# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: display current scope context in a C file"
HOMEPAGE="http://www.bluweb.com/us/chouser/proj/ctx/"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ia64 ppc x86"

VIM_PLUGIN_HELPURI="http://www.bluweb.com/us/chouser/proj/ctx/"

# bug #74897
RDEPEND="!app-vim/enhancedcommentify"

# See bug 591068.
DEPEND="app-editors/vim[perl]"
