# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Python implementation of the parquet columnar file format"
HOMEPAGE="https://github.com/dask/fastparquet"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="brotli lzo +snappy"

RDEPEND="
	dev-python/numba[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/thriftpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	brotli? ( app-arch/brotli[python,${PYTHON_USEDEP}] )
	lzo? ( dev-python/python-lzo[${PYTHON_USEDEP}] )
	snappy? ( dev-python/snappy[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
"
