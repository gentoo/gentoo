# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy)

inherit distutils-r1

DESCRIPTION="A featureful, correct URL for Python"
HOMEPAGE="https://github.com/python-hyper/hyperlink https://pypi.python.org/pypi/hyperlink"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-2.9.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-2.3.0[${PYTHON_USEDEP}]
	)
"

python_test() {
	PYTHONPATH="${S}/test:${BUILD_DIR}/lib" \
		py.test -v || die
	cd test
}
