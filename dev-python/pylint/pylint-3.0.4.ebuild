# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

MY_P=${P/_beta/b}
DESCRIPTION="Python code static checker"
HOMEPAGE="
	https://pypi.org/project/pylint/
	https://github.com/pylint-dev/pylint/
"
SRC_URI="
	https://github.com/pylint-dev/pylint/archive/v${PV/_beta/b}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="examples"

# Make sure to check https://github.com/pylint-dev/pylint/blob/main/pyproject.toml#L34 on bumps
# Adjust dep bounds!
RDEPEND="
	<dev-python/astroid-3.1[${PYTHON_USEDEP}]
	>=dev-python/astroid-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/dill-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/isort-4.2.5[${PYTHON_USEDEP}]
	<dev-python/isort-6[${PYTHON_USEDEP}]
	>=dev-python/mccabe-0.6[${PYTHON_USEDEP}]
	<dev-python/mccabe-0.8[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.10.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-1.1.0[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			>=dev-python/GitPython-3[${PYTHON_USEDEP}]
		' 'python*' )
		<dev-python/pytest-8[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		'tests/test_functional.py::test_functional[dataclass_with_field]'

		# incompatible versions of numpy/scikit-learn?
		'tests/test_functional.py::test_functional[no_name_in_module]'
		'tests/test_functional.py::test_functional[shadowed_import]'
	)
	local EPYTEST_IGNORE=(
		# No need to run the benchmarks
		tests/benchmark/test_baseline_benchmarks.py
	)

	if [[ ${EPYTHON} == pypy3 ]]; then
		# Requires GitPython
		EPYTEST_IGNORE+=(
			tests/profile/test_profile_against_externals.py
			tests/testutils/_primer/test_package_to_lint.py
			tests/testutils/_primer/test_primer.py
		)
	fi

	rm -rf pylint || die

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p timeout
}

python_install_all() {
	if use examples ; then
		docompress -x "/usr/share/doc/${PF}/examples"
		docinto examples
		dodoc -r examples/.
	fi

	distutils-r1_python_install_all
}
