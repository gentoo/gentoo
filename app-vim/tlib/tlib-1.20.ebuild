# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vim-plugin

MY_PN=${PN}_vim
MY_P=${MY_PN}-${PV}

DESCRIPTION="vim plugin: a library of utility functions"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1863 https://github.com/tomtom/tlib_vim"
SRC_URI="https://github.com/tomtom/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

S=${WORKDIR}/${MY_P}

src_prepare() {
	rm -r test samples addon-info.json || die
}
