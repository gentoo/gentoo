# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Task scheduling and blocked algorithms for parallel processing"
HOMEPAGE="https://dask.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="distributed test"

RDEPEND="
	>=dev-python/cloudpickle-0.2.1[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.19[${PYTHON_USEDEP}]
	>=dev-python/partd-0.3.8[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/toolz-0.7.3[${PYTHON_USEDEP}]
	distributed? (
		  >=dev-python/distributed-1.16[${PYTHON_USEDEP}]
		  >=dev-python/s3fs-0.0.8[${PYTHON_USEDEP}]
	)
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/toolz[${PYTHON_USEDEP}]
	test? (
	   ${RDEPEND}
	   dev-python/pytest[${PYTHON_USEDEP}]
	   dev-python/numexpr[${PYTHON_USEDEP}]
	   sci-libs/scipy[${PYTHON_USEDEP}]
	)
"
python_test() {
	py.test || die
}
