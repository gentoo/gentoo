# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/tpg/tpg-3.2.2-r1.ebuild,v 1.7 2015/04/14 12:51:37 ago Exp $

EAPI=5
# py2.6 doesn't pass tests
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MY_P="TPG-${PV}"

DESCRIPTION="Toy Parser Generator for Python"
HOMEPAGE="http://christophe.delord.free.fr/tpg/index.html"
SRC_URI="http://christophe.delord.free.fr/tpg/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ia64 ppc x86"
IUSE="doc examples"
DOCS=( ChangeLog README THANKS doc/tpg.pdf )

S="${WORKDIR}/${MY_P}"

python_test() {
	"${PYTHON}" tpg_tests.py -v || die
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
