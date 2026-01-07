# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

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

# qiskit-aer requires slamch_ that is provided by openblas or flexiblas
# but not sci-libs/lapack.  Link with openblas for now.
# <nlohmann_json-3.10.3 for https://github.com/Qiskit/qiskit-aer/issues/1742
DEPEND="
	>=dev-python/numpy-1.16.3[${PYTHON_USEDEP}]
	<dev-cpp/nlohmann_json-3.10.3
	>=dev-cpp/nlohmann_json-3.1.1
	>=dev-libs/spdlog-1.9.2:=
	>=dev-cpp/muParserX-4.0.8
	sci-libs/openblas
"
RDEPEND="
	${DEPEND}
	>=dev-python/psutil-5[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/qiskit-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-build/cmake-3.17
	>=dev-python/scikit-build-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/pybind11-2.6[${PYTHON_USEDEP}]
	test? (
		dev-python/ddt[${PYTHON_USEDEP}]
		dev-python/fixtures[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

PATCHES=(
	# workaround intrusive and harmful Gentoo patching to CMake
	# https://bugs.gentoo.org/736547
	"${FILESDIR}/qiskit-aer-0.17.2-workaround-gentoo-cmake.patch"
)

src_configure() {
	export DISABLE_CONAN="ON"
	export DISABLE_DEPENDENCY_INSTALL="ON"
	export SKBUILD_CONFIGURE_OPTIONS="-DTEST_JSON=1"
}

python_test() {
	local EPYTEST_DESELECT=(
		# requires qiskit_qasm3_import
		test/terra/backends/aer_simulator/test_save_statevector.py::TestSaveStatevector::test_save_statevector_for_qasm3_circuit_1___automatic____CPU__
		test/terra/backends/aer_simulator/test_save_statevector.py::TestSaveStatevector::test_save_statevector_for_qasm3_circuit_2___statevector____CPU__
		test/terra/backends/aer_simulator/test_save_statevector.py::TestSaveStatevector::test_save_statevector_for_qasm3_circuit_3___matrix_product_state____CPU__
		test/terra/backends/aer_simulator/test_save_statevector.py::TestSaveStatevector::test_save_statevector_for_qasm3_circuit_4___extended_stabilizer____CPU__
	)

	local EPYTEST_IGNORE=(
		# TODO: qiskit.providers.aer? wtf?
		test/terra/expression/test_classical_expressions.py
	)

	# From tox.ini/tests.yml in CI
	# Needed to suppress a warning in jupyter-core 5.x by eagerly migrating to
	# a new internal interface that will be the default in jupyter-core 6.x.
	# This variable should become redundant on release of jupyter-core 6.
	local -x JUPYTER_PLATFORM_DIRS=1

	rm -rf qiskit_aer || die
	epytest -s
}

pkg_postinst() {
	check_openblas
}
