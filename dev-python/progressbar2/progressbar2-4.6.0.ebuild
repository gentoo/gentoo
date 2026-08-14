# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/wolph/python-progressbar
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Text progressbar library for python"
HOMEPAGE="
	https://progressbar-2.readthedocs.io/
	https://github.com/wolph/python-progressbar/
	https://pypi.org/project/progressbar2/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/python-utils-3.8.1[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/dill-0.3.6[${PYTHON_USEDEP}]
		>=dev-python/freezegun-0.3.11[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# wall clock timing
		tests/test_fastpath.py::test_iterator_overhead_is_low
	)

	local -x PYTHONDONTWRITEBYTECODE=1
	epytest tests
}
