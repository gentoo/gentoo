# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="Access and share datasets for Audio, Computer Vision, and NLP tasks"
HOMEPAGE="https://pypi.org/project/datasets/"
SRC_URI="https://github.com/huggingface/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	${PYTHON_DEPS}
	sci-ml/caffe2[${PYTHON_SINGLE_USEDEP},numpy]
	sci-ml/huggingface_hub[${PYTHON_SINGLE_USEDEP}]
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/dill[${PYTHON_USEDEP}]
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/fsspec[${PYTHON_USEDEP}]
		dev-python/multiprocess[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pyarrow[${PYTHON_USEDEP},parquet,snappy]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/xxhash[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"
BDEPEND="test? (
	sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/decorator[${PYTHON_USEDEP}]
		dev-python/pytest-datadir[${PYTHON_USEDEP}]
		dev-python/scikit-learn[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/zstandard[${PYTHON_USEDEP}]
		sci-ml/jiwer[${PYTHON_USEDEP}]
		sci-ml/seqeval[${PYTHON_USEDEP}]
	')
)"

PATCHES=(
	"${FILESDIR}"/${P}-tests.patch
)

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e \
		"/pyarrow_hotfix/d" \
		src/datasets/features/features.py || die
}

src_test() {
	local EPYTEST_IGNORE=(
		tests/features/test_audio.py
		tests/test_fingerprint.py
		tests/packaged_modules/test_audiofolder.py
		tests/packaged_modules/test_spark.py
		tests/test_iterable_dataset.py
	)

	local EPYTEST_DESELECT=(
		tests/packaged_modules/test_cache.py::test_cache_multi_configs
		tests/packaged_modules/test_cache.py::test_cache_single_config
		tests/test_arrow_dataset.py::BaseDatasetTest::test_filter_caching_on_disk
		tests/test_arrow_dataset.py::BaseDatasetTest::test_map_caching_on_disk
		tests/test_distributed.py::test_torch_distributed_run
		tests/test_file_utils.py::TestxPath::test_xpath_rglob
		tests/test_file_utils.py::TestxPath::test_xpath_glob
		tests/test_hub.py::test_convert_to_parquet
	)
	distutils-r1_src_test
}
