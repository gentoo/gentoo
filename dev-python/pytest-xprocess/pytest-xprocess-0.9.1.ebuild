# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Manage external processes across test runs"
HOMEPAGE="https://pypi.python.org/pypi/pytest-xprocess/ https://bitbucket.org/pytest-dev/pytest-xprocess"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	|| (
		dev-python/pytest-cache[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.8.0[${PYTHON_USEDEP}]
	)
	dev-python/psutil[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( >=dev-python/pytest-2.3.5[${PYTHON_USEDEP}]
		dev-python/pytest-cache[${PYTHON_USEDEP}] )
"

python_test() {
	PYTEST_PLUGINS="pytest_xprocess" py.test -v -v || die
}
