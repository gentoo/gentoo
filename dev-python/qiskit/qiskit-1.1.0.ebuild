# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

CRATES="
	ahash@0.7.8
	ahash@0.8.11
	allocator-api2@0.2.18
	always-assert@0.1.3
	approx@0.5.1
	ariadne@0.3.0
	autocfg@1.2.0
	bitflags@1.3.2
	bitflags@2.5.0
	block-buffer@0.10.4
	boolenum@0.1.0
	bytemuck@1.15.0
	bytemuck_derive@1.6.0
	byteorder@1.5.0
	cfg-if@1.0.0
	coe-rs@0.1.2
	concolor-query@0.3.3
	concolor@0.1.1
	countme@3.0.1
	cov-mark@2.0.0-pre.1
	cpufeatures@0.2.12
	crossbeam-channel@0.5.12
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.19
	crunchy@0.2.2
	crypto-common@0.1.6
	dbgf@0.1.2
	digest@0.10.7
	drop_bomb@0.1.5
	dyn-stack@0.10.0
	either@1.11.0
	enum-as-inner@0.6.0
	equator-macro@0.1.9
	equator@0.1.10
	equivalent@1.0.1
	faer-entity@0.18.0
	faer-ext@0.1.0
	faer@0.18.2
	fixedbitset@0.4.2
	gemm-c32@0.17.1
	gemm-c64@0.17.1
	gemm-common@0.17.1
	gemm-f16@0.17.1
	gemm-f32@0.17.1
	gemm-f64@0.17.1
	gemm@0.17.1
	generic-array@0.14.7
	getrandom@0.2.14
	half@2.4.1
	hashbrown@0.12.3
	hashbrown@0.14.5
	heck@0.4.1
	hermit-abi@0.3.9
	indexmap@1.9.3
	indexmap@2.2.6
	indoc@2.0.5
	is-terminal@0.4.12
	itertools@0.10.5
	itertools@0.11.0
	itertools@0.12.1
	jod-thread@0.1.2
	libc@0.2.154
	libm@0.2.8
	lock_api@0.4.12
	log@0.4.21
	matrixcompare-core@0.1.0
	matrixcompare@0.3.0
	matrixmultiply@0.3.8
	memchr@2.7.2
	memoffset@0.9.1
	miow@0.5.0
	ndarray@0.15.6
	npyz@0.8.3
	num-bigint@0.4.4
	num-complex@0.4.5
	num-integer@0.1.46
	num-traits@0.2.18
	numpy@0.21.0
	once_cell@1.19.0
	oq3_lexer@0.6.0
	oq3_parser@0.6.0
	oq3_semantics@0.6.0
	oq3_source_file@0.6.0
	oq3_syntax@0.6.0
	parking_lot@0.12.2
	parking_lot_core@0.9.10
	paste@1.0.14
	pest@2.7.10
	pest_derive@2.7.10
	pest_generator@2.7.10
	pest_meta@2.7.10
	petgraph@0.6.4
	portable-atomic@1.6.0
	ppv-lite86@0.2.17
	priority-queue@1.4.0
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.81
	pulp-macro@0.1.1
	pulp@0.18.10
	py_literal@0.4.0
	pyo3-build-config@0.21.2
	pyo3-ffi@0.21.2
	pyo3-macros-backend@0.21.2
	pyo3-macros@0.21.2
	pyo3@0.21.2
	quote@1.0.36
	ra_ap_limit@0.0.188
	ra_ap_stdx@0.0.188
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rand_distr@0.4.3
	rand_pcg@0.3.1
	raw-cpuid@10.7.0
	rawpointer@0.2.1
	rayon-cond@0.3.0
	rayon-core@1.12.1
	rayon@1.10.0
	reborrow@0.5.5
	redox_syscall@0.5.1
	rowan@0.15.15
	rustc-hash@1.1.0
	rustversion@1.0.15
	rustworkx-core@0.14.2
	same-file@1.0.6
	scopeguard@1.2.0
	seq-macro@0.3.5
	serde@1.0.200
	serde_derive@1.0.200
	sha2@0.10.8
	smallvec@1.13.2
	smol_str@0.2.1
	syn@1.0.109
	syn@2.0.60
	sysctl@0.5.5
	target-lexicon@0.12.14
	text-size@1.1.1
	thiserror-impl@1.0.59
	thiserror@1.0.59
	triomphe@0.1.11
	typenum@1.17.0
	ucd-trie@0.1.6
	unicode-ident@1.0.12
	unicode-properties@0.1.1
	unicode-width@0.1.12
	unicode-xid@0.2.4
	unindent@0.2.3
	version_check@0.9.4
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.8
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.42.0
	windows-sys@0.45.0
	windows-sys@0.52.0
	windows-targets@0.42.2
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.52.5
	xshell-macros@0.2.6
	xshell@0.2.6
	yansi@0.5.1
	zerocopy-derive@0.7.32
	zerocopy@0.7.32
"

inherit cargo distutils-r1

MY_P=qiskit-${PV}
DESCRIPTION="An open-source SDK for working with quantum computers"
HOMEPAGE="
	https://github.com/Qiskit/qiskit/
	https://pypi.org/project/qiskit/
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
KEYWORDS="~amd64"
IUSE="+visualization"

RDEPEND="
	>=dev-python/dill-0.3[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.17[${PYTHON_USEDEP}]
	>=dev-python/python-constraint-1.4[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/rustworkx-0.14.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.5[${PYTHON_USEDEP}]
	>=dev-python/stevedore-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/symengine-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/sympy-1.3[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.10)
	visualization? (
		>=dev-python/matplotlib-3.3[${PYTHON_USEDEP}]
		dev-python/pydot[${PYTHON_USEDEP}]
		>=dev-python/pillow-4.2.1[${PYTHON_USEDEP}]
		>=dev-python/pylatexenc-1.4[${PYTHON_USEDEP}]
		>=dev-python/seaborn-0.9.0[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	>=dev-python/cython-0.27.1[${PYTHON_USEDEP}]
	test? (
		app-text/poppler[png]
		>=dev-python/ddt-1.4.4[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-4.24.3[${PYTHON_USEDEP}]
		>=dev-python/networkx-2.2[${PYTHON_USEDEP}]
		<dev-python/pytest-8.2[${PYTHON_USEDEP}]
		>=dev-python/qiskit-aer-0.14[${PYTHON_USEDEP}]
		>=dev-python/scikit-learn-0.20.0[${PYTHON_USEDEP}]
	)
"

# Files built without CFLAGS/LDFLAGS, acceptable for rust
QA_FLAGS_IGNORED="
	usr/lib.*/py.*/site-packages/qiskit/_accelerate.*.so
	usr/lib.*/py.*/site-packages/qiskit/_qasm2.*.so
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	# strip forcing -Werror from tests that also leaks to other packages
	sed -i -e '/filterwarnings.*error/d' test/utils/base.py || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		test/python/circuit/test_equivalence.py::TestEquivalenceLibraryVisualization::test_equivalence_draw
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
	epytest test/python
}
