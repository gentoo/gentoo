# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1 optfeature

DESCRIPTION="Library for operating on mathematical expressions with multi-dimensional arrays"
HOMEPAGE="https://github.com/pymc-devs/Theano-PyMC"
SRC_URI="https://github.com/pymc-devs/Theano-PyMC/archive/rel-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/Theano-PyMC-rel-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]"

distutils_enable_sphinx doc 'dev-python/sphinx_rtd_theme'
distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e "s/, 'flake8'//" setup.py || die
	sed -i -e "s/tests.\*/tests\*/" setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	pytest -vv || die "Tests failed with ${EPYTHON}"
}

pkg_postinst() {
	optfeature "GPU code generation/execution on NVIDIA gpus" dev-util/nvidia-cuda-toolkit dev-util/nvidia-cuda-sdk
	optfeature "GPU/CPU code generation on CUDA and OpenCL devices" dev-libs/libgpuarray dev-python/pycuda
}
