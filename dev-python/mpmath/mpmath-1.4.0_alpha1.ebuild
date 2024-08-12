# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Python library for arbitrary-precision floating-point arithmetic"
HOMEPAGE="
	https://mpmath.org/
	https://github.com/mpmath/mpmath/
	https://pypi.org/project/mpmath/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/gmpy[${PYTHON_USEDEP}]
		' 'python3*')
		$(python_gen_cond_dep '
			dev-python/ipython[${PYTHON_USEDEP}]
		' 3.{10..12})
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		mpmath/tests/test_cli.py::test_bare_console_bare_division
		mpmath/tests/test_cli.py::test_bare_console_no_bare_division
		mpmath/tests/test_cli.py::test_bare_console_pretty
		mpmath/tests/test_cli.py::test_bare_console_without_ipython
		mpmath/tests/test_cli.py::test_bare_console_wrap_floats
		# precision problems on some arches, also np2
		# https://github.com/mpmath/mpmath/pull/816
		# https://github.com/mpmath/mpmath/issues/836
		mpmath/tests/test_convert.py::test_compatibility
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p rerunfailures --reruns=5
}

pkg_postinst() {
	optfeature "gmp support" dev-python/gmpy
	optfeature "matplotlib support" dev-python/matplotlib
}
