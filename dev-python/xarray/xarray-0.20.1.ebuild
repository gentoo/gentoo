# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# pkg_resources use in code
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="N-D labeled arrays and datasets in Python"
HOMEPAGE="https://xarray.pydata.org/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/numpy-1.18[${PYTHON_USEDEP}]
	>=dev-python/pandas-1.1[${PYTHON_USEDEP}]"
# note: most of test dependencies are optional
BDEPEND="
	test? (
		dev-python/bottleneck[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/toolz[${PYTHON_USEDEP}]
		!hppa? ( >=dev-python/scipy-1.4[${PYTHON_USEDEP}] )
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-0.19.0-riscv_tests_datetime.patch
)

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# warning-targeted tests are fragile and not important to end users
		xarray/tests/test_backends.py::test_no_warning_from_dask_effective_get
	)

	epytest ${deselect[@]/#/--deselect }
}
