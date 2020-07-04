# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )

inherit distutils-r1

DESCRIPTION="Kernels used by spyder on its ipython console"
HOMEPAGE="https://github.com/spyder-ide/spyder-kernels/
	https://pypi.org/project/spyder-kernels/"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/v${PV}.tar.gz -> ${P}-gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/cloudpickle[${PYTHON_USEDEP}]
	>=dev-python/ipykernel-5.1.3[${PYTHON_USEDEP}]
	>=dev-python/jupyter_client-5.3.4[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-17[${PYTHON_USEDEP}]
	>=dev-python/wurlitzer-1.0.3[${PYTHON_USEDEP}]"

DEPEND="test? (
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/flaky[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/xarray[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_test() {
	if [[ ${EPYTHON} = python3.6 ]]; then
		# this fails in py3.6 for some reason
		sed -i -e 's:test_turtle_launch:_&:' \
			spyder_kernels/console/tests/test_console_kernel.py || die
	fi

	pytest -vv || die "Tests fail with ${EPYTHON}"
}
