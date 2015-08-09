# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit python-single-r1

DESCRIPTION="Command-line tool to paste to paste.kde.org"
HOMEPAGE="http://projects.kde.org/projects/playground/utils/kpaste"
SRC_URI="http://dev.gentoo.org/~kensington/distfiles/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_compile() {
	:
}

src_install() {
	dobin kpaste
	dodoc README

	python_fix_shebang "${ED}"usr/bin/kpaste
}
