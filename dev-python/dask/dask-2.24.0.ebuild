# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1 multiprocessing

DESCRIPTION="Task scheduling and blocked algorithms for parallel processing"
HOMEPAGE="https://dask.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="distributed"

RDEPEND="
	>=dev-python/cloudpickle-0.2.2[${PYTHON_USEDEP}]
	>=dev-python/fsspec-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.13.0[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.23.4[${PYTHON_USEDEP}]
	>=dev-python/partd-0.3.10[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/toolz-0.8.2[${PYTHON_USEDEP}]
	distributed? (
		>=dev-python/distributed-2.0[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	dev-python/toolz[${PYTHON_USEDEP}]
	test? (
		dev-python/numexpr[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		>=dev-python/s3fs-0.0.8[${PYTHON_USEDEP}]
		sci-libs/scipy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	pytest -vv -m "not network" \
		-n "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")" ||
		die "Tests failed with ${EPYTHON}"
}
