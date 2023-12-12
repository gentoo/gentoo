# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

CRATES="
	ahash@0.8.3
	allocator-api2@0.2.16
	autocfg@1.1.0
	bitflags@1.3.2
	cfg-if@1.0.0
	crossbeam-deque@0.8.3
	crossbeam-epoch@0.9.15
	crossbeam-utils@0.8.16
	either@1.9.0
	equivalent@1.0.1
	fixedbitset@0.4.2
	getrandom@0.2.10
	hashbrown@0.12.3
	hashbrown@0.14.0
	indexmap@1.9.3
	indexmap@2.0.1
	indoc@1.0.9
	itertools@0.10.5
	libc@0.2.147
	libm@0.2.7
	lock_api@0.4.10
	matrixmultiply@0.3.7
	memoffset@0.9.0
	ndarray@0.15.6
	num-bigint@0.4.4
	num-complex@0.4.4
	num-integer@0.1.45
	num-traits@0.2.16
	numpy@0.19.0
	once_cell@1.18.0
	parking_lot@0.12.1
	parking_lot_core@0.9.8
	petgraph@0.6.3
	ppv-lite86@0.2.17
	priority-queue@1.3.2
	proc-macro2@1.0.66
	pyo3-build-config@0.19.2
	pyo3-ffi@0.19.2
	pyo3-macros-backend@0.19.2
	pyo3-macros@0.19.2
	pyo3@0.19.2
	quote@1.0.32
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rand_distr@0.4.3
	rand_pcg@0.3.1
	rawpointer@0.2.1
	rayon-cond@0.2.0
	rayon-core@1.12.0
	rayon@1.8.0
	redox_syscall@0.3.5
	rustc-hash@1.1.0
	rustworkx-core@0.13.2
	scopeguard@1.2.0
	smallvec@1.11.1
	syn@1.0.109
	target-lexicon@0.12.11
	unicode-ident@1.0.11
	unindent@0.1.11
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	windows-targets@0.48.2
	windows_aarch64_gnullvm@0.48.2
	windows_aarch64_msvc@0.48.2
	windows_i686_gnu@0.48.2
	windows_i686_msvc@0.48.2
	windows_x86_64_gnu@0.48.2
	windows_x86_64_gnullvm@0.48.2
	windows_x86_64_msvc@0.48.2
"

inherit cargo distutils-r1 multiprocessing optfeature

MY_P=qiskit-${PV}
DESCRIPTION="Terra is the foundation on which Qiskit is built"
HOMEPAGE="
	https://github.com/Qiskit/qiskit/
	https://pypi.org/project/qiskit-terra/
"
SRC_URI="
	https://github.com/Qiskit/qiskit/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 MIT
	Unicode-DFS-2016
	|| ( LGPL-3 MPL-2.0 )
"
SLOT="0"
IUSE="+visualization"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/rustworkx-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.17[${PYTHON_USEDEP}]
	>=dev-python/ply-3.10[${PYTHON_USEDEP}]
	>=dev-python/psutil-5[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.5[${PYTHON_USEDEP}]
	>=dev-python/sympy-1.3[${PYTHON_USEDEP}]
	>=dev-python/dill-0.3[${PYTHON_USEDEP}]
	>=dev-python/python-constraint-1.4[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/symengine-0.11.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.10)
	visualization? (
		>=dev-python/matplotlib-3.3[${PYTHON_USEDEP}]
		>=dev-python/ipywidgets-7.3.0[${PYTHON_USEDEP}]
		dev-python/pydot[${PYTHON_USEDEP}]
		>=dev-python/pillow-4.2.1[${PYTHON_USEDEP}]
		>=dev-python/pylatexenc-1.4[${PYTHON_USEDEP}]
		>=dev-python/seaborn-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.4[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	>=dev-python/cython-0.27.1[${PYTHON_USEDEP}]
	test? (
		app-text/poppler[png]
		>=dev-python/ddt-1.4.4[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-4.24.3[${PYTHON_USEDEP}]
		>=dev-python/networkx-2.2[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		<dev-python/qiskit-aer-0.13[${PYTHON_USEDEP}]
		>=sci-libs/scikit-learn-0.20.0[${PYTHON_USEDEP}]
	)
"

# Files built without CFLAGS/LDFLAGS, acceptable for rust
QA_FLAGS_IGNORED="
	usr/lib.*/py.*/site-packages/qiskit/_accelerate.*.so
	usr/lib.*/py.*/site-packages/qiskit/_qasm2.*.so
"

distutils_enable_tests pytest

src_prepare() {
	# strip forcing -Werror from tests that also leaks to other packages
	sed -i -e '/filterwarnings.*error/d' qiskit/test/base.py || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		test/python/circuit/test_equivalence.py::TestEquivalenceLibraryVisualization::test_equivalence_draw
		test/python/primitives/test_backend_estimator.py::TestBackendEstimator::test_bound_pass_manager
		test/python/primitives/test_backend_sampler.py::TestBackendSampler::test_bound_pass_manager
		test/python/transpiler/aqc/test_aqc.py::TestAqc::test_aqc_deprecation
		test/python/transpiler/test_unitary_synthesis_plugin.py::TestUnitarySynthesisPlugin
		test/python/visualization/test_dag_drawer.py::TestDagDrawer::test_dag_drawer_no_register
	)

	local EPYTEST_IGNORE=(
		# Breaks xdist
		test/python/qasm2/test_parse_errors.py
	)

	rm -rf qiskit || die
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# Run the Python test suite rather than everything under test/ which
	# includes the 'randomized' suite. Upstream run that in a separate CI job.
	# Note: use -p timeout --timeout 500 if debugging hanging tests.
	epytest -p xdist -n "$(makeopts_jobs)" --dist=worksteal test/python
}

pkg_postinst() {
	optfeature "qiskit.circuit.classicalfunction support" dev-python/tweedledum
}
