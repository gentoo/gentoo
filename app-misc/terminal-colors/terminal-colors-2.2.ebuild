# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="ncurses"

inherit python-r1

DESCRIPTION="A tool to display color charts for 8, 16, 88, and 256 color terminals"
HOMEPAGE="http://zhar.net/projects/shell/terminal-colors"
SRC_URI="https://dev.gentoo.org/~radhermit/distfiles/${P}.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"

RDEPEND="${PYTHON_DEPS}"

S=${WORKDIR}

src_install() {
	python_foreach_impl python_newscript ${P} ${PN}
}
