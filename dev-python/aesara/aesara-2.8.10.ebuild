# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# A whole bunch of test failures with 3.11
PYTHON_COMPAT=( python3_{9..10} )

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
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/aesara-2.6.5-compiledir-tid.patch
	"${FILESDIR}"/aesara-2.8.10-fix-tuple.patch
)

distutils_enable_sphinx doc 'dev-python/sphinx-rtd-theme'
distutils_enable_tests pytest

src_prepare() {
	# do not claim "bin" package (sic!)
	rm bin/__init__.py || die
	distutils-r1_src_prepare

	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}

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

		# Deprecation warning causes unexpected additional output
		tests/tensor/test_basic.py::TestLongTensor::test_fit_int64

		# dunno
		tests/tensor/test_elemwise.py::TestDimShuffle::test_memory_leak
		tests/tensor/signal/test_pool.py::TestDownsampleFactorMax::test_DownsampleFactorMaxGradGrad_grad

		# TODO
		tests/link/c/test_op.py::test_ExternalCOp_c_code_cache_version
		tests/sparse/sandbox/test_sp.py::TestSP::test_multilayer_conv
		tests/sparse/sandbox/test_sp.py::TestSP::test_maxpool

		# TODO: Package pytest-benchmark
		tests/scan/test_basic.py::TestExamples::test_reordering
		tests/scan/test_basic.py::TestExamples::test_scan_as_tensor_on_gradients
		tests/scan/test_basic.py::TestExamples::test_multiple_outs_taps
		tests/scan/test_rewriting.py::TestPushOutAddScan::test_pregreedy_optimizer
		tests/scan/test_rewriting.py::TestSaveMem::test_savemem_opt
		tests/scan/test_basic.py::test_cython_performance
	)
	local EPYTEST_IGNORE=(
		# we do not package jax or numba
		tests/link/jax
		tests/link/numba
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x AESARA_FLAGS="cxx=${CXX}"
	AESARA_FLAGS+=",config.gcc__cxxflags=\"${CXXFLAGS}\""
	AESARA_FLAGS+=',compiledir_format="compiledir_%(thread_id)s"'

	epytest -p xdist.plugin -n "$(makeopts_jobs)"
	# clean up the compiledir, as it can grow pretty large
	rm -r "${HOME}"/.aesara || die
}

pkg_postinst() {
	optfeature "GPU code generation/execution on NVIDIA gpus" dev-util/nvidia-cuda-toolkit
	optfeature "GPU/CPU code generation on CUDA and OpenCL devices" dev-libs/libgpuarray dev-python/pycuda
}
