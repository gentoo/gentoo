# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 multiprocessing

DESCRIPTION="High performance simulator for quantum circuits that includes noise models"
HOMEPAGE="
	https://github.com/Qiskit/qiskit-aer/
	https://pypi.org/project/qiskit-aer/
"
SRC_URI="
	https://github.com/Qiskit/qiskit-aer/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# The reference implementation of BLAS/CBLAS is not compatible with qiskit-aer right now,
# because importing library causes an error.
# /usr/lib/python3.9/site-packages/qiskit/providers/aer/backends/controller_wrappers.cpython-39-x86_64-linux-gnu.so: undefined symbol: slamch_
# Using sci-libs/openblas instead here,
# with the option to switch between reference/openblas implementation runtime (eselect-ldso).
#
# <nlohmann_json-3.10.3 for https://github.com/Qiskit/qiskit-aer/issues/1742
DEPEND="
	>=dev-python/numpy-1.16.3[${PYTHON_USEDEP}]
	<dev-cpp/nlohmann_json-3.10.3
	>=dev-cpp/nlohmann_json-3.1.1
	>=dev-libs/spdlog-1.9.2:=
	>=dev-cpp/muParserX-4.0.8
	virtual/cblas[eselect-ldso]
	sci-libs/openblas[eselect-ldso]
"
RDEPEND="
	${DEPEND}
	>=dev-python/psutil-5[${PYTHON_USEDEP}]
	>=dev-python/qiskit-terra-0.25.1-r1[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-util/cmake-3.17
	>=dev-python/scikit-build-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/pybind11-2.6[${PYTHON_USEDEP}]
	test? (
		dev-python/ddt[${PYTHON_USEDEP}]
		dev-python/fixtures[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

check_openblas() {
	local libdir=$(get_libdir) me="openblas"

	# check blas
	local current_blas=$(eselect blas show ${libdir} | cut -d' ' -f2)
	if [[ ${current_blas} != "${me}" ]]; then
		eerror "Current eselect: BLAS/CBLAS ($libdir) -> [${current_blas}]."
		eerror "To use qiskit-aer, you have to issue (as root):"
		eerror "\t eselect blas set ${libdir} ${me}"
		return 1
	fi
	return 0
}

pkg_setup() {
	if use test; then
		check_openblas
		if [[ $? -ne 0 ]]; then
			die "Set blas implementation to openblas using 'eselect blas set openblas'!"
		fi
	fi
}

python_prepare_all() {
	export DISABLE_CONAN="ON"
	export DISABLE_DEPENDENCY_INSTALL="ON"
	export SKBUILD_CONFIGURE_OPTIONS="-DTEST_JSON=1"

	# remove meaningless dep on the metapackage
	sed -i -e '/qiskit>=/d' setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		test/terra/states/test_aer_state.py::TestAerState::test_appply_diagonal
		test/terra/states/test_aer_state.py::TestAerState::test_appply_measure
		test/terra/states/test_aer_state.py::TestAerState::test_appply_reset

		# TODO: GLIBCXX_ASSERTIONS, bug #897758
		test/terra/backends/aer_simulator/test_algorithms.py::TestAlgorithms::test_extended_stabilizer_sparse_output_probs
		test/terra/backends/aer_simulator/test_options.py::TestOptions::test_mps_options
		test/terra/backends/aer_simulator/test_fusion.py::TestGateFusion::test_parallel_fusion_diagonal

		# requires qiskit_qasm3_import
		test/terra/backends/aer_simulator/test_save_statevector.py::TestSaveStatevector::test_save_statevector_for_qasm3_circuit_1___automatic____CPU__
		test/terra/backends/aer_simulator/test_save_statevector.py::TestSaveStatevector::test_save_statevector_for_qasm3_circuit_2___statevector____CPU__
		test/terra/backends/aer_simulator/test_save_statevector.py::TestSaveStatevector::test_save_statevector_for_qasm3_circuit_3___matrix_product_state____CPU__
		test/terra/backends/aer_simulator/test_save_statevector.py::TestSaveStatevector::test_save_statevector_for_qasm3_circuit_4___extended_stabilizer____CPU__
	)

	# From tox.ini/tests.yml in CI
	# Needed to suppress a warning in jupyter-core 5.x by eagerly migrating to
	# a new internal interface that will be the default in jupyter-core 6.x.
	# This variable should become redundant on release of jupyter-core 6.
	local -x JUPYTER_PLATFORM_DIRS=1

	rm -rf qiskit_aer || die
	epytest -n "$(makeopts_jobs)" -s
}

pkg_postinst() {
	check_openblas
}
