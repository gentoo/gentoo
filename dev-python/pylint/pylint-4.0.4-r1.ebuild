# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="examples"

RDEPEND="
	<dev-python/astroid-4.1[${PYTHON_USEDEP}]
	>=dev-python/astroid-4.0.2[${PYTHON_USEDEP}]
	>=dev-python/dill-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/isort-5.14[${PYTHON_USEDEP}]
	<dev-python/isort-8[${PYTHON_USEDEP}]
	>=dev-python/mccabe-0.6[${PYTHON_USEDEP}]
	<dev-python/mccabe-0.8[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.10.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			>=dev-python/gitpython-3[${PYTHON_USEDEP}]
		' 'python*' )
		>=dev-python/pytest-8.3[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.12[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-timeout )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		'tests/test_functional.py::test_functional[dataclass_with_field]'
		'tests/test_functional.py::test_functional[no_name_in_module]'
		'tests/test_functional.py::test_functional[shadowed_import]'
		'tests/test_functional.py::test_functional[use_yield_from]'
	)
	local EPYTEST_IGNORE=(
		# No need to run the benchmarks
		tests/benchmark/test_baseline_benchmarks.py
	)

	if ! has_version "dev-python/gitpython[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=(
			tests/profile/test_profile_against_externals.py
			tests/testutils/_primer/test_package_to_lint.py
			tests/testutils/_primer/test_primer.py
		)
	fi

	epytest
}

python_install_all() {
	if use examples ; then
		docompress -x "/usr/share/doc/${PF}/examples"
		docinto examples
		dodoc -r examples/.
	fi

	distutils-r1_python_install_all
}
