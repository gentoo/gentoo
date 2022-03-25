# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Python code static checker"
HOMEPAGE="
	https://www.logilab.org/project/pylint
	https://pypi.org/project/pylint/
	https://github.com/pycqa/pylint/
"
SRC_URI="
	https://github.com/pycqa/pylint/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~riscv ~x86"
IUSE="examples"

# Make sure to check https://github.com/PyCQA/pylint/blob/main/setup.cfg#L43 on bumps
# Adjust dep bounds!
RDEPEND="
	<dev-python/astroid-2.12[${PYTHON_USEDEP}]
	>=dev-python/astroid-2.11.0[${PYTHON_USEDEP}]
	>=dev-python/dill-0.2[${PYTHON_USEDEP}]
	>=dev-python/isort-4.2.5[${PYTHON_USEDEP}]
	<dev-python/isort-6[${PYTHON_USEDEP}]
	>=dev-python/mccabe-0.6[${PYTHON_USEDEP}]
	<dev-python/mccabe-0.8[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/tomli-1.1.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.8 3.9)
"
BDEPEND="
	test? (
		>=dev-python/GitPython-3[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.4.4-sphinx-theme.patch"
)

distutils_enable_sphinx doc --no-autodoc
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# No need to run the benchmarks
		tests/benchmark/test_baseline_benchmarks.py

		# TODO
		'tests/test_functional.py::test_functional[forgotten_debug_statement_py37]'
		'tests/test_functional.py::test_functional[dataclass_with_field]'
		tests/checkers/unittest_typecheck.py::TestTypeChecker::test_nomember_on_c_extension_error_msg
		tests/checkers/unittest_typecheck.py::TestTypeChecker::test_nomember_on_c_extension_info_msg
	)
	# Specify the test directory explicitly to avoid import file mismatches
	epytest tests
}

python_install_all() {
	if use examples ; then
		docompress -x "/usr/share/doc/${PF}/examples"
		docinto examples
		dodoc -r examples/.
	fi

	distutils-r1_python_install_all
}
