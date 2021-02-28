# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# pkg_resources use in code
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="N-D labeled arrays and datasets in Python"
HOMEPAGE="https://xarray.pydata.org/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/numpy-1.17[${PYTHON_USEDEP}]
	>=dev-python/pandas-1.0[${PYTHON_USEDEP}]"
# note: most of test dependencies are optional
BDEPEND="
	test? (
		dev-python/bottleneck[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/toolz[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.4[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
