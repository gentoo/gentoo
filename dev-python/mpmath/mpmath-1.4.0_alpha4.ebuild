# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Python library for arbitrary-precision floating-point arithmetic"
HOMEPAGE="
	https://mpmath.org/
	https://github.com/mpmath/mpmath/
	https://pypi.org/project/mpmath/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm arm64 hppa ~loong ~mips ppc ~ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/gmpy2[${PYTHON_USEDEP}]
		' 'python3*')
		!mips? (
			!hppa? (
				dev-python/matplotlib[${PYTHON_USEDEP}]
			)
		)
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# minor whitespace mismatch, apparently fixed in pypy 7.3.18
				mpmath/tests/test_format.py::test_mpf_floats_bulk
				mpmath/tests/test_format.py::test_mpc_complexes
			)
			;;
	esac

	# CLI crashes otherwise, sigh (not a regression)
	# https://github.com/mpmath/mpmath/issues/907
	> "${HOME}/.python_history" || die

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p rerunfailures --reruns=5 -p timeout
}

pkg_postinst() {
	optfeature "gmp support" dev-python/gmpy2
	optfeature "matplotlib support" dev-python/matplotlib
}
