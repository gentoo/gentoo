# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

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

# The reference implementation of BLAS/CBLAS is not compatible with qiskit-aer right now,
# because importing library causes an error.
# /usr/lib/python3.9/site-packages/qiskit/providers/aer/backends/controller_wrappers.cpython-39-x86_64-linux-gnu.so: undefined symbol: slamch_
# Using sci-libs/openblas instead here,
# with the option to switch between reference/openblas implementation runtime (eselect-ldso).
DEPEND="
	>=dev-python/numpy-1.16.3[${PYTHON_USEDEP}]
	>=dev-cpp/nlohmann_json-3.1.1
	>=dev-libs/spdlog-1.5.0
	>=dev-cpp/muParserX-4.0.8
	virtual/cblas[eselect-ldso]
	sci-libs/openblas[eselect-ldso]
"

BDEPEND="
	>=dev-util/cmake-3.17
	>=dev-python/scikit-build-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/pybind11-2.6[${PYTHON_USEDEP}]
	test? (
		dev-python/ddt[${PYTHON_USEDEP}]
		dev-python/fixtures[${PYTHON_USEDEP}]
	)
"

RDEPEND="
	${DEPEND}
	>=dev-python/qiskit-terra-0.21.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

# Remove cmake dependency from setup.py because of
# invalid dependency description. We put this dependency check in BDEPEND.
PATCHES=( "${FILESDIR}/qiskit-aer-0.10.3-remove-cmake-dependency.patch" )

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
		if [ $? -ne 0 ]; then
			die "Set blas implementation to openblas using 'eselect blas set openblas'!"
		fi
	fi
}

python_prepare_all() {
	export DISABLE_CONAN="ON"
	export DISABLE_DEPENDENCY_INSTALL="ON"
	#export SKBUILD_CONFIGURE_OPTIONS=""

	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		test/terra/states/test_aer_statevector.py::TestAerStatevector::test_number_to_latex_terms
	)

	rm -rf qiskit_aer || die
	epytest -s
}

pkg_postinst() {
	check_openblas
}
