# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="High Level Expressions for Dask"
HOMEPAGE="
	https://github.com/dask/dask-expr/
	https://pypi.org/project/dask-expr/
"
# pypi tarball removes tests, as of 1.0.1
SRC_URI="
	https://github.com/dask/dask-expr/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/dask-2024.3.0[${PYTHON_USEDEP}]
	>=dev-python/pyarrow-7.0.0[${PYTHON_USEDEP}]
	>=dev-python/pandas-2[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/versioneer[${PYTHON_USEDEP}]
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	# unpin
	sed -i -e '/dask/s:==:>=:' pyproject.toml || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# requires distributed
		'dask_expr/tests/test_shuffle.py::test_respect_context_shuffle[shuffle]'
	)
	local EPYTEST_IGNORE=(
		# requires distributed
		dask_expr/io/tests/test_parquet.py
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
