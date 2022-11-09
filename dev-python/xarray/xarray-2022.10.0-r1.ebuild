# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="N-D labeled arrays and datasets in Python"
HOMEPAGE="https://xarray.pydata.org/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~s390 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/numpy-1.22[${PYTHON_USEDEP}]
	>=dev-python/pandas-1.3[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.0[${PYTHON_USEDEP}]
"
# note: most of the test dependencies are optional
BDEPEND="
	test? (
		dev-python/bottleneck[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/toolz[${PYTHON_USEDEP}]
		!hppa? ( >=dev-python/scipy-1.4[${PYTHON_USEDEP}] )
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# warning-targeted tests are fragile and not important to end users
	xarray/tests/test_backends.py::test_no_warning_from_dask_effective_get
)
