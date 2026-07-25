# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi virtualx

DESCRIPTION="Python to GNU Octave bridge"
HOMEPAGE="
	https://github.com/blink1073/oct2py
	https://blink1073.github.io/oct2py/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/numpy-1.25.0[${PYTHON_USEDEP}]
	>=dev-python/octave-kernel-1.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-settings-2.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-0.17.1[${PYTHON_USEDEP}]
	>=dev-python/tornado-0.5.5[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/ipython-9.0[${PYTHON_USEDEP}]
		dev-python/nbconvert[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( flaky )
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# No graphics toolkit available: 743589
		"oct2py/ipython/tests/test_octavemagic.py::OctaveMagicTest::test_octave_plot"
		# TODO
		tests/test_misc.py::TestMisc::test_func_without_docstring
		tests/test_usage.py::TestUsage::test_pkg_load
	)

	virtx epytest
}
