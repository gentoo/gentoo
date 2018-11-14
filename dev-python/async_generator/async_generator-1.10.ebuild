# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Making it easy to write async iterators in Python 3.5"
HOMEPAGE="https://github.com/python-trio/async_generator https://pypi.org/project/async_generator/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

DOCS=( README.rst )

python_test() {
	py.test -v || die "tests failed under ${EPYTHON}"
}
