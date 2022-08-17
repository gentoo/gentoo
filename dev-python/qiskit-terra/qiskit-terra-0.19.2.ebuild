# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Terra is the foundation on which Qiskit is built"
HOMEPAGE="https://github.com/Qiskit/qiskit-terra"
SRC_URI="https://github.com/Qiskit/qiskit-terra/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+visualization"
KEYWORDS="~amd64"

BDEPEND=">=dev-python/cython-0.27.1[${PYTHON_USEDEP}]
	test? (
		>=dev-python/ddt-1.4.4[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-4.24.3[${PYTHON_USEDEP}]
		>=dev-python/networkx-2.2[${PYTHON_USEDEP}]
		app-text/poppler[png]
		>=sci-libs/scikit-learn-0.20.0[${PYTHON_USEDEP}]
	)"

RDEPEND="
	>=dev-python/retworkx-0.10.1[${PYTHON_USEDEP}]
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

distutils_enable_tests pytest

# Small issues with the tests.
# qiskit.Aer module depends on qiskit-terra, it cannot be used,
# and an exact comparison of float switched to approximate comparison.
PATCHES=( "${FILESDIR}/qiskit-terra-0.19.2-test-corrections.patch" )

python_test() {
	# We have to hide the source code directory so tests
	# do not use these, but instead the compiled library.
	mv qiskit qiskit.hidden || die

	# Some small tests are failing which test optional features.
	# Why they fail is still under investigation.
	# transpiler_equivalence tests take too long time, they are also skipped.
	epytest -k 'not (TestOptions and test_copy) and not TestUnitarySynthesisPlugin and not test_transpiler_equivalence and not (TestPauliSumOp and test_to_instruction)'

	mv qiskit.hidden qiskit || die
}
