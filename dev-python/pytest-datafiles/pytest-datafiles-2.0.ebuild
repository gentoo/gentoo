# Copyright 2018 Sony Interactive Entertainment Inc.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

DESCRIPTION="pytest plugin to create a tmpdir containing a preconfigured set of files/dirs"
HOMEPAGE="https://github.com/omarkohl/pytest-datafiles"
SRC_URI="https://github.com/omarkohl/${PN}/archive/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="dev-python/py[${PYTHON_USEDEP}]
	>=dev-python/pytest-3.6.0[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"

python_test() {
	distutils_install_for_testing
	PYTHONPATH="${TEST_DIR}"/lib pytest -v || die "Tests fail with ${EPYTHON}"
}
