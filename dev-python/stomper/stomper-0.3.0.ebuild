# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
# Supports only py2 pypy
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Transport neutral client implementation of the STOMP protocol"
HOMEPAGE="https://pypi.org/project/stomper/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="examples"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_prepare_all() {
	mv lib/${PN}/examples . || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
