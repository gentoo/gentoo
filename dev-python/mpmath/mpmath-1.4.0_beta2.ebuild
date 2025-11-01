# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_FULLY_TESTED=( pypy3_11 python3_{11..13} )
PYTHON_COMPAT=( "${PYTHON_FULLY_TESTED[@]}" python3_14 )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Python library for arbitrary-precision floating-point arithmetic"
HOMEPAGE="
	https://mpmath.org/
	https://github.com/mpmath/mpmath/
	https://pypi.org/project/mpmath/
"

LICENSE="BSD"
SLOT="0"
IUSE="test-full"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pexpect[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/gmpy2-2.3.0_alpha1[${PYTHON_USEDEP}]
		' 'python3*')
		test-full? (
			$(python_gen_cond_dep '
				dev-python/matplotlib[${PYTHON_USEDEP}]
			' "${PYTHON_FULLY_TESTED[@]}")
		)
	)
"

EPYTEST_PLUGINS=( hypothesis pytest-timeout )
EPYTEST_RERUNS=5
EPYTEST_XDIST=1
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Slow and often needs a re-run to pass
	mpmath/tests/test_cli.py::test_bare_console_bare_division
	mpmath/tests/test_cli.py::test_bare_console_no_bare_division
	mpmath/tests/test_cli.py::test_bare_console_pretty
	mpmath/tests/test_cli.py::test_bare_console_without_ipython
	mpmath/tests/test_cli.py::test_bare_console_wrap_floats
)

pkg_postinst() {
	optfeature "gmp support" dev-python/gmpy2
	optfeature "matplotlib support" dev-python/matplotlib
}
