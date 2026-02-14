# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/scikit-hep/awkward
PYTHON_COMPAT=( python3_{11..14} )

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
	~dev-python/awkward-cpp-51[${PYTHON_USEDEP}]
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
	# fails if just caffe2 but not pytorch is installed
	tests/test_3259_to_torch_from_torch.py
)

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	# CUDA tests require cupy
	epytest tests
}
