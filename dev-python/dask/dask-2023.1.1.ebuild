# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Task scheduling and blocked algorithms for parallel processing"
HOMEPAGE="
	https://www.dask.org/
	https://github.com/dask/dask/
	https://pypi.org/project/dask/
"
SRC_URI="
	https://github.com/dask/dask/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/cloudpickle-0.2.2[${PYTHON_USEDEP}]
	>=dev-python/fsspec-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.15.1[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.25.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
	>=dev-python/partd-0.3.10[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
	>=dev-python/toolz-0.8.2[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/toolz[${PYTHON_USEDEP}]
	test? (
		dev-python/moto[${PYTHON_USEDEP}]
		dev-python/numexpr[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# another test relying on -Werror
	"dask/array/tests/test_overlap.py::test_map_overlap_no_depth[None]"
	# TODO
	dask/array/tests/test_reductions.py::test_mean_func_does_not_warn
	dask/tests/test_config.py::test__get_paths
	dask/array/tests/test_linalg.py::test_solve_assume_a
	"dask/dataframe/tests/test_dataframe.py::test_repartition_npartitions[<lambda>0-float-5-1-True]"
	"dask/dataframe/tests/test_dataframe.py::test_repartition_npartitions[<lambda>1-float-5-1-True]"
	# require sqlalchemy<2.0
	dask/dataframe/io/tests/test_sql.py
)

src_prepare() {
	# fails with sqlalchemy-2.0, even though we don't use it x_x
	sed -i -e '/RemovedIn20Warning/d' setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	epytest -p no:flaky -m "not network"
}
