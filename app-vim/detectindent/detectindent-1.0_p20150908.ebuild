# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: automatically detect file indent settings"
HOMEPAGE="https://github.com/ciaranm/detectindent"
LICENSE="vim"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE=""

if [[ ${PV} != 9999* ]] ; then
	SRC_URI="mirror://gentoo/${P}.tar.xz
		http://dev.gentoo.org/~chutzpah/vim/${P}.tar.xz"
fi

DEPEND="app-arch/xz-utils"

VIM_PLUGIN_HELPFILES="detectindent.txt"
