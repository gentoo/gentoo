# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit distutils-r1

DESCRIPTION="pytest plugin to check source code with pylint"
HOMEPAGE="https://github.com/carsongee/pytest-pylint"
SRC_URI="https://github.com/carsongee/pytest-pylint/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-pep8[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# pytest grabs the options from tox.ini automatically
	# but setup.py does not declare pytest-pep8 as a dep,
	# so it's missing from env created by distutils_install_for_testing
	sed -i -e 's:--pep8::' tox.ini || die
	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	py.test -v || die "Tests fail with ${EPYTHON}"
}
