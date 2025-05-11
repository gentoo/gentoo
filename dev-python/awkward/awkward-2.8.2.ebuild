# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1 pypi

DESCRIPTION="Manipulate JSON-like data with NumPy-like idioms"
HOMEPAGE="
	https://github.com/scikit-hep/awkward
	https://pypi.org/project/awkward/
	https://doi.org/10.5281/zenodo.4341376
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	~dev-python/awkward-cpp-45[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/importlib-metadata-4.13.0[${PYTHON_USEDEP}]
	' 3.11)
	>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/fsspec-2022.11.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	test? (
		dev-libs/apache-arrow[zstd]
		dev-python/pyarrow[${PYTHON_USEDEP}]
		dev-python/numexpr[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
	)
"
		#dev-python/numba[${PYTHON_USEDEP}] # needs numba from sci

EPYTEST_IGNORE=(
	tests-cuda/
	tests-cuda-kernels/
	# fails if just caffe2 but not pytorch is installed
	tests/test_3259_to_torch_from_torch.py
	# no idea why it fails, seems to be a numexpr error
	# see https://github.com/scikit-hep/awkward/issues/3402
	tests/test_0119_numexpr_and_broadcast_arrays.py
	tests/test_1125_to_arrow_from_arrow.py
	tests/test_1294_to_and_from_parquet.py
	tests/test_1440_start_v2_to_parquet.py
)

distutils_enable_tests pytest
