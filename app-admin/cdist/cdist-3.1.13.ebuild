# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4} )
inherit distutils-r1

DESCRIPTION="A usable configuration management system"
HOMEPAGE="http://www.nico.schottelius.org/software/cdist/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DOCS=( README )

python_install_all() {
	if use doc; then
		HTML_DOCS=( docs/man/man1/*.html docs/man/man7/*.html )
	fi
	distutils-r1_python_install_all
	doman docs/man/man1/*.1 docs/man/man7/*.7
}
