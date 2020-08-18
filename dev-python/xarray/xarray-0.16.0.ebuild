# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# pkg_resources use in code
DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="N-D labeled arrays and datasets in Python"
HOMEPAGE="https://xarray.pydata.org/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/numpy-1.15[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.25[${PYTHON_USEDEP}]
	>=dev-python/setuptools-41.2[${PYTHON_USEDEP}]"
# note: most of test dependencies are optional
BDEPEND="
	test? (
		dev-python/bottleneck[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/toolz[${PYTHON_USEDEP}]
		>=sci-libs/scipy-1.1[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

PATCHES=(
#	"${FILESDIR}/${PN}-0.10.8-skip-broken-test.patch"
)
