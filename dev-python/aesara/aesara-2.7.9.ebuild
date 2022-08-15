# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 multiprocessing optfeature

MY_P=aesara-rel-${PV}
DESCRIPTION="Library for operating on mathematical expressions with multi-dimensional arrays"
HOMEPAGE="
	https://github.com/aesara-devs/aesara/
	https://pypi.org/project/aesara/
"
SRC_URI="
	https://github.com/aesara-devs/aesara/archive/rel-${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	dev-python/cons[${PYTHON_USEDEP}]
	dev-python/etuples[${PYTHON_USEDEP}]
	dev-python/logical-unification[${PYTHON_USEDEP}]
	dev-python/minikanren[${PYTHON_USEDEP}]
	dev-python/filelock[${PYTHON_USEDEP}]
	<dev-python/numpy-1.23[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	>=dev-python/setuptools-45[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/aesara-2.6.5-compiledir-tid.patch
)

distutils_enable_sphinx doc 'dev-python/sphinx_rtd_theme'
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# speed tests are unreliable
		tests/scan/test_basic.py::test_speed
		tests/scan/test_basic.py::test_speed_rnn
		tests/scan/test_basic.py::test_speed_batchrnn
		tests/link/test_vm.py::test_speed
		tests/link/test_vm.py::test_speed_lazy
		tests/tensor/test_gc.py::test_merge_opt_runtime

		# rounding problem?
		# https://github.com/aesara-devs/aesara/issues/477
		tests/tensor/test_math_scipy.py::TestGammaUBroadcast::test_good
		tests/tensor/test_math_scipy.py::TestGammaUInplaceBroadcast::test_good

		# dunno
		'tests/tensor/test_elemwise.py::TestDimShuffle::test_memory_leak[False]'
	)
	local EPYTEST_IGNORE=(
		# we do not package numba
		tests/link/test_numba.py
		tests/link/test_numba_performance.py
		# ..or jax
		tests/link/test_jax.py
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x AESARA_FLAGS="cxx=${CXX}"
	AESARA_FLAGS+=",config.gcc__cxxflags=\"${CXXFLAGS}\""
	AESARA_FLAGS+=',compiledir_format="compiledir_%(thread_id)s"'

	epytest -p xdist.plugin -n "$(makeopts_jobs)"
	# clean up the compiledir, as it can grow pretty large
	rm -r "${HOME}"/.aesara || die
}

python_compile() {
	distutils-r1_python_compile
	rm "${BUILD_DIR}/install$(python_get_sitedir)/bin/__init__.py" || die
}

pkg_postinst() {
	optfeature "GPU code generation/execution on NVIDIA gpus" dev-util/nvidia-cuda-toolkit dev-util/nvidia-cuda-sdk
	optfeature "GPU/CPU code generation on CUDA and OpenCL devices" dev-libs/libgpuarray dev-python/pycuda
}
