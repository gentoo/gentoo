# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Python implementation of the parquet columnar file format"
HOMEPAGE="https://github.com/dask/fastparquet"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux"
IUSE="brotli lz4 lzo +snappy zstd"

RDEPEND="
	dev-python/numba[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/thrift[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	brotli? ( app-arch/brotli[python,${PYTHON_USEDEP}] )
	lzo? ( dev-python/python-lzo[${PYTHON_USEDEP}] )
	lz4? ( dev-python/lz4[${PYTHON_USEDEP}] )
	snappy? ( dev-python/snappy[${PYTHON_USEDEP}] )
	zstd? ( dev-python/zstandard[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
"

src_prepare() {
	# this causes setuptool's sandbox violations, Portage should have
	# taken care of this, so disable it
	sed -i -e 's/setup_requires/disabled_setup_requires/' setup.py || die

	distutils-r1_src_prepare
}
