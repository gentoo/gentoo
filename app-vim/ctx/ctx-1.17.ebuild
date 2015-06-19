# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/ctx/ctx-1.17.ebuild,v 1.12 2013/11/05 15:14:11 chainsaw Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: display current scope context in a C file"
HOMEPAGE="http://www.bluweb.com/us/chouser/proj/ctx/"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ia64 ppc x86"
IUSE=""
VIM_PLUGIN_HELPURI="http://www.bluweb.com/us/chouser/proj/ctx/"

# bug #74897
RDEPEND="!app-vim/enhancedcommentify"
