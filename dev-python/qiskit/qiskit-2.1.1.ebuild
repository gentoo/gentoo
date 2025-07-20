# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit cargo distutils-r1

MY_P=${P/_}
DESCRIPTION="An open-source SDK for working with quantum computers"
HOMEPAGE="
	https://github.com/Qiskit/qiskit/
	https://pypi.org/project/qiskit/
"
SRC_URI="
	https://github.com/Qiskit/qiskit/archive/${PV/_}.tar.gz
		-> ${MY_P}.gh.tar.gz
	${CARGO_CRATE_URIS}
	https://github.com/gentoo-crate-dist/qiskit/releases/download/${PV/_}/${MY_P}-crates.tar.xz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 MIT MPL-2.0
	Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+visualization"

RDEPEND="
	>=dev-python/dill-0.3[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.17[${PYTHON_USEDEP}]
	>=dev-python/python-constraint-1.4[${PYTHON_USEDEP}]
	>=dev-python/rustworkx-0.15.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.5[${PYTHON_USEDEP}]
	>=dev-python/stevedore-3.0.0[${PYTHON_USEDEP}]
	visualization? (
		>=dev-python/matplotlib-3.3[${PYTHON_USEDEP}]
		dev-python/pydot[${PYTHON_USEDEP}]
		>=dev-python/pillow-4.2.1[${PYTHON_USEDEP}]
		>=dev-python/pylatexenc-1.4[${PYTHON_USEDEP}]
		>=dev-python/seaborn-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/symengine-0.11.0[${PYTHON_USEDEP}]
		>=dev-python/sympy-1.3[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	>=dev-python/cython-0.27.1[${PYTHON_USEDEP}]
	test? (
		app-text/poppler[png]
		>=dev-python/ddt-1.4.4[${PYTHON_USEDEP}]
		>=dev-python/networkx-2.2[${PYTHON_USEDEP}]
		>=dev-python/qiskit-aer-0.14[${PYTHON_USEDEP}]
		>=dev-python/scikit-learn-0.20.0[${PYTHON_USEDEP}]
	)
"

# Files built without CFLAGS/LDFLAGS, acceptable for rust
QA_FLAGS_IGNORED="
	usr/lib.*/py.*/site-packages/qiskit/_accelerate.*.so
	usr/lib.*/py.*/site-packages/qiskit/_qasm2.*.so
"

EPYTEST_PLUGINS=( hypothesis )
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# strip forcing -Werror from tests that also leaks to other packages
	sed -i -e '/filterwarnings.*error/d' test/utils/base.py || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		test/python/circuit/test_equivalence.py::TestEquivalenceLibraryVisualization::test_equivalence_draw
		test/python/transpiler/test_unitary_synthesis_plugin.py::TestUnitarySynthesisPlugin
		test/python/visualization/test_dag_drawer.py::TestDagDrawer::test_dag_drawer_no_register
		# tiny image differences, sigh
		test/python/visualization/test_gate_map.py::TestGateMap::test_plot_error_map_over_100_qubit
		# TODO: failures from dill
		test/python/circuit/test_parameters.py::TestParameters::test_transpiling_multiple_parameterized_circuits
		test/python/compiler/test_transpiler.py::TestTranspile::test_delay_converts_expr_to_dt
		test/python/compiler/test_transpiler.py::TestTranspile::test_transpile_two
		test/python/transpiler/test_naming_transpiled_circuits.py::TestNamingTranspiledCircuits::test_multiple_circuits_name_list
	)

	local EPYTEST_IGNORE=(
		# Breaks xdist
		test/python/qasm2/test_parse_errors.py
		test/python/transpiler/test_preset_passmanagers.py
	)

	rm -rf qiskit || die
	# Run the Python test suite rather than everything under test/ which
	# includes the 'randomized' suite. Upstream run that in a separate CI job.
	epytest test/python
}
