# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1 optfeature

MY_P=aesara-rel-${PV}
DESCRIPTION="Library for operating on mathematical expressions with multi-dimensional arrays"
HOMEPAGE="https://github.com/pymc-devs/aesara"
SRC_URI="https://github.com/pymc-devs/aesara/archive/rel-${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	dev-python/filelock[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx doc 'dev-python/sphinx_rtd_theme'
distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e "s/tests.\*/tests\*/" setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local exclude=(
		# speed tests are unreliable
		tests/scan/test_basic.py::test_speed
		tests/scan/test_basic.py::test_speed_rnn
		tests/scan/test_basic.py::test_speed_batchrnn
		tests/link/test_vm.py::test_speed
		tests/link/test_vm.py::test_speed_lazy
		tests/tensor/test_gc.py::test_merge_opt_runtime
	)

	distutils_install_for_testing --via-root
	pytest -vv ${exclude[@]/#/--deselect } \
		-n "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")" ||
		die "Tests fail with ${EPYTHON}"
}

# https://dev.gentoo.org/~mgorny/python-guide/concept.html#packaging-pkgutil-style-namespaces-in-gentoo
python_install() {
	rm "${BUILD_DIR}"/lib/bin/__init__.py || die
	distutils-r1_python_install
}

pkg_postinst() {
	optfeature "GPU code generation/execution on NVIDIA gpus" dev-util/nvidia-cuda-toolkit dev-util/nvidia-cuda-sdk
	optfeature "GPU/CPU code generation on CUDA and OpenCL devices" dev-libs/libgpuarray dev-python/pycuda
}
