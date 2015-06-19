# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/terminal-colors/terminal-colors-2.0.ebuild,v 1.3 2015/04/08 07:30:33 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3} )
PYTHON_REQ_USE="ncurses"

inherit python-r1

DESCRIPTION="A tool to display color charts for 8, 16, 88, and 256 color terminals"
HOMEPAGE="http://zhar.net/projects/shell/terminal-colors"
SRC_URI="http://dev.gentoo.org/~radhermit/distfiles/${P}.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="${PYTHON_DEPS}"

S=${WORKDIR}

src_install() {
	python_foreach_impl python_newscript ${P} ${PN}
}
