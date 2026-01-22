# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_PN=${PN#ensurepip-}
PYPI_VERIFY_REPO=https://github.com/pypa/wheel
# PYTHON_COMPAT used only for testing
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Shared wheel wheel for use in pip tests"
HOMEPAGE="
	https://github.com/pypa/wheel/
	https://pypi.org/project/wheel/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	test? (
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

# xdist is slightly flaky here
EPYTEST_PLUGINS=( pytest-rerunfailures )
EPYTEST_RERUNS=5
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_compile() {
	# If we're testing, install for all implementations.
	# If we're not, just get one wheel built.
	if use test || [[ -z ${DISTUTILS_WHEEL_PATH} ]]; then
		distutils-r1_python_compile
	fi
}

python_test() {
	local EPYTEST_DESELECT=(
		# fails if any setuptools plugin imported the module first
		tests/test_bdist_wheel.py::test_deprecated_import
	)

	epytest
}

src_install() {
	if [[ ${DISTUTILS_WHEEL_PATH} != *py3-none-any.whl ]]; then
		die "Non-pure wheel produced?! ${DISTUTILS_WHEEL_PATH}"
	fi
	# TODO: compress it?
	insinto /usr/lib/python/ensurepip
	doins "${DISTUTILS_WHEEL_PATH}"
}
