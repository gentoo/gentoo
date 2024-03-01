# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="A simple, correct PEP517 package builder"
HOMEPAGE="
	https://pypi.org/project/build/
	https://github.com/pypa/build/
"
SRC_URI="
	https://github.com/pypa/build/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/packaging-19.0[${PYTHON_USEDEP}]
	dev-python/pyproject-hooks[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-1.1.0[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		>=dev-python/filelock-3[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-2[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-9.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-1.34[${PYTHON_USEDEP}]
		>=dev-python/setuptools-56.0.0[${PYTHON_USEDEP}]
		>=dev-python/wheel-0.36.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# broken by the presence of flit_core
		tests/test_util.py::test_wheel_metadata_isolation
		# broken by the presence of virtualenv (it changes the error
		# messages, sic!)
		'tests/test_main.py::test_output[via-sdist-isolation]'
		'tests/test_main.py::test_output[wheel-direct-isolation]'
		# broken when built in not normal tty on coloring
		tests/test_main.py::test_colors
		'tests/test_main.py::test_output_env_subprocess_error[color]'
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -m "not network" -p pytest_mock -p rerunfailures
}
