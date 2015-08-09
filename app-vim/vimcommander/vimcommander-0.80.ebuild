# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit vim-plugin

MY_PV=${PV/0./}
MY_P=${PN}-${MY_PV}

DESCRIPTION="vim plugin: Total Commander style file explorer"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=808"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ia64 ppc sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

VIM_PLUGIN_HELPFILES="vimcommander"

S=${WORKDIR}/${MY_P}
