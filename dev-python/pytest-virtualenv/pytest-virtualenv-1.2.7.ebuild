# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Virtualenv fixture for py.test"
HOMEPAGE="https://github.com/manahl/pytest-plugins https://pypi.python.org/pypi/pytest-virtualenv"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/pytest-fixture-config[${PYTHON_USEDEP}]
	dev-python/pytest-shutil[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/setuptools-git[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

python_test() {
	distutils_install_for_testing

	esetup.py test || die "Tests failed under ${EPYTHON}"
}
