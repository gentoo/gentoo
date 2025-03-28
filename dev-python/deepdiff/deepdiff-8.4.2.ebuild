# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A library for comparing dictionaries, iterables, strings and other objects"
HOMEPAGE="
	https://github.com/seperman/deepdiff/
	https://pypi.org/project/deepdiff/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/click-8.1.3[${PYTHON_USEDEP}]
	<dev-python/orderly-set-6[${PYTHON_USEDEP}]
	>=dev-python/orderly-set-5.3.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
"

DEPEND="
	test? (
		>=dev-python/jsonpickle-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.23.5[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/tomli-w[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/tomli[${PYTHON_USEDEP}]
		' 3.10)
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# benchmarks
		tests/test_lfucache.py::TestLFUcache::test_lfu
		# requires polars
		tests/test_hash.py::TestDeepHashPrep::test_polars
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
