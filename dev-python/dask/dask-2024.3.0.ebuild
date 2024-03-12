# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

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
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/click-8.1[${PYTHON_USEDEP}]
	>=dev-python/cloudpickle-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/fsspec-2021.9.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.21[${PYTHON_USEDEP}]
	>=dev-python/pandas-1.3[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
	>=dev-python/partd-1.2.0[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
	>=dev-python/toolz-0.10.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/importlib-metadata-4.13.0[${PYTHON_USEDEP}]
	' 3.{10..11})
"
BDEPEND="
	dev-python/toolz[${PYTHON_USEDEP}]
	>=dev-python/versioneer-0.28[${PYTHON_USEDEP}]
	test? (
		dev-python/dask-expr[${PYTHON_USEDEP}]
		dev-python/moto[${PYTHON_USEDEP}]
		dev-python/numexpr[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	# fails with sqlalchemy-2.0, even though we don't use it x_x
	sed -i -e '/RemovedIn20Warning/d' pyproject.toml || die
	sed -i -e 's:--cov-config=pyproject.toml::' pyproject.toml || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# more tests relying on -Werror
		"dask/array/tests/test_overlap.py::test_map_overlap_no_depth[None]"
		dask/array/tests/test_random.py::test_RandomState_only_funcs
		dask/dataframe/tests/test_dataframe.py::test_view
		dask/dataframe/tests/test_shuffle.py::test_npartitions_auto_raises_deprecation_warning
		# TODO
		dask/array/tests/test_reductions.py::test_mean_func_does_not_warn
		dask/tests/test_config.py::test__get_paths
		dask/array/tests/test_linalg.py::test_solve_assume_a
		"dask/dataframe/tests/test_dataframe.py::test_repartition_npartitions[<lambda>0-float-5-1-True]"
		"dask/dataframe/tests/test_dataframe.py::test_repartition_npartitions[<lambda>1-float-5-1-True]"
		dask/array/tests/test_image.py::test_preprocess
		dask/tests/test_system.py::test_cpu_count_cgroups_v2
		# require sqlalchemy<2.0
		dask/dataframe/io/tests/test_sql.py
		# crashes
		dask/tests/test_base.py::test_tokenize_object_with_recursion_error
		# regression with new pandas (?)
		dask/dataframe/tests/test_multi.py::test_concat5
	)

	if ! has_version -b "dev-python/pyarrow[parquet,${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			# fails if pyarrow is installed without USE=parquet
			# (optional dep, skipped if it's not installed at all)
			dask/dataframe/io/tests/test_parquet.py::test_pyarrow_filter_divisions
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_rerunfailures -m "not network" -o xfail_strict=False
}
