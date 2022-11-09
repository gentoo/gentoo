# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash-0.7.6
	ahash-0.8.0
	autocfg-1.1.0
	bitflags-1.3.2
	cfg-if-1.0.0
	crossbeam-channel-0.5.6
	crossbeam-deque-0.8.2
	crossbeam-epoch-0.9.11
	crossbeam-utils-0.8.12
	either-1.8.0
	fixedbitset-0.4.2
	getrandom-0.2.7
	hashbrown-0.11.2
	hashbrown-0.12.3
	hermit-abi-0.1.19
	indexmap-1.9.1
	indoc-1.0.7
	libc-0.2.135
	libm-0.2.5
	lock_api-0.4.9
	matrixmultiply-0.3.2
	memoffset-0.6.5
	ndarray-0.15.6
	num-bigint-0.4.3
	num-complex-0.4.2
	num_cpus-1.13.1
	num-integer-0.1.45
	numpy-0.16.2
	num-traits-0.2.15
	once_cell-1.15.0
	parking_lot-0.12.1
	parking_lot_core-0.9.3
	petgraph-0.6.2
	ppv-lite86-0.2.16
	proc-macro2-1.0.46
	pyo3-0.16.6
	pyo3-build-config-0.16.6
	pyo3-ffi-0.16.6
	pyo3-macros-0.16.6
	pyo3-macros-backend-0.16.6
	quote-1.0.21
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	rand_distr-0.4.3
	rand_pcg-0.3.1
	rawpointer-0.2.1
	rayon-1.5.3
	rayon-core-1.9.3
	redox_syscall-0.2.16
	retworkx-core-0.11.0
	scopeguard-1.1.0
	smallvec-1.10.0
	syn-1.0.102
	target-lexicon-0.12.4
	unicode-ident-1.0.5
	unindent-0.1.10
	version_check-0.9.4
	wasi-0.11.0+wasi-snapshot-preview1
	windows_aarch64_msvc-0.36.1
	windows_i686_gnu-0.36.1
	windows_i686_msvc-0.36.1
	windows-sys-0.36.1
	windows_x86_64_gnu-0.36.1
	windows_x86_64_msvc-0.36.1
"

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit cargo distutils-r1 multiprocessing

DESCRIPTION="Terra is the foundation on which Qiskit is built"
HOMEPAGE="https://github.com/Qiskit/qiskit-terra"
SRC_URI="https://github.com/Qiskit/qiskit-terra/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
SRC_URI+=" $(cargo_crate_uris)"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+visualization"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/rustworkx-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.17[${PYTHON_USEDEP}]
	>=dev-python/ply-3.10[${PYTHON_USEDEP}]
	>=dev-python/psutil-5[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.5[${PYTHON_USEDEP}]
	>=dev-python/sympy-1.3[${PYTHON_USEDEP}]
	>=dev-python/dill-0.3[${PYTHON_USEDEP}]
	>=dev-python/python-constraint-1.4[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/symengine-0.8[${PYTHON_USEDEP}]
	>=dev-python/tweedledum-1.1[${PYTHON_USEDEP}]
	visualization? (
		>=dev-python/matplotlib-3.3[${PYTHON_USEDEP}]
		>=dev-python/ipywidgets-7.3.0[${PYTHON_USEDEP}]
		dev-python/pydot[${PYTHON_USEDEP}]
		>=dev-python/pillow-4.2.1[${PYTHON_USEDEP}]
		>=dev-python/pylatexenc-1.4[${PYTHON_USEDEP}]
		>=dev-python/seaborn-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.4[${PYTHON_USEDEP}]
	)"
BDEPEND="
	>=dev-python/cython-0.27.1[${PYTHON_USEDEP}]
	test? (
		app-text/poppler[png]
		>=dev-python/ddt-1.4.4[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-4.24.3[${PYTHON_USEDEP}]
		>=dev-python/networkx-2.2[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/qiskit-aer[${PYTHON_USEDEP}]
		>=sci-libs/scikit-learn-0.20.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	find -name '*.py' -exec sed -i -e 's:retworkx:rustworkx:' {} + || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		test/python/transpiler/test_unitary_synthesis_plugin.py::TestUnitarySynthesisPlugin
		test/python/transpiler/test_unitary_synthesis.py::TestUnitarySynthesis::test_two_qubit_synthesis_not_pulse_optimal
	)
	local EPYTEST_IGNORE=(
		# TODO, also apparently slow
		test/randomized/test_transpiler_equivalence.py
	)

	rm -rf qiskit || die
	epytest -p xdist -n "$(makeopts_jobs)"
}
