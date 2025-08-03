# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="makes evaluating, comparing models and reporting their performance easier"
HOMEPAGE="
	https://pypi.org/project/evaluate/
	https://github.com/huggingface/evaluate
"
SRC_URI="https://github.com/huggingface/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+evaluator +template +torch"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/dill[${PYTHON_USEDEP}]
		dev-python/fsspec[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/multiprocess[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pyarrow[${PYTHON_USEDEP},parquet]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/unidecode[${PYTHON_USEDEP}]
		dev-python/xxhash[${PYTHON_USEDEP}]
		evaluator? (
			dev-python/scipy[${PYTHON_USEDEP}]
		)
		template? (
			dev-util/cookiecutter[${PYTHON_USEDEP}]
		)
	')
	sci-ml/datasets[${PYTHON_SINGLE_USEDEP}]
	sci-ml/huggingface_hub[${PYTHON_SINGLE_USEDEP}]
	evaluator? (
		sci-ml/transformers[${PYTHON_SINGLE_USEDEP}]
	)
	torch? (
		sci-ml/caffe2[${PYTHON_SINGLE_USEDEP},distributed]
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	)
"
BDEPEND="test? (
	$(python_gen_cond_dep '
		sci-ml/jiwer[${PYTHON_USEDEP}]
		sci-ml/seqeval[${PYTHON_USEDEP}]
	')
)"

PATCHES=( "${FILESDIR}"/${PN}-0.4.0-tests.patch )

distutils_enable_tests pytest

src_test() {
	local EPYTEST_DESELECT=(
		tests/test_evaluation_suite.py::TestEvaluationSuite::test_empty_suite
		tests/test_evaluation_suite.py::TestEvaluationSuite::test_running_evaluation_suite
		tests/test_evaluator.py::TestAudioClassificationEvaluator::test_class_init
		tests/test_evaluator.py::TestAudioClassificationEvaluator::test_overwrite_default_metric
		tests/test_evaluator.py::TestAudioClassificationEvaluator::test_pipe_init
		tests/test_evaluator.py::TestAudioClassificationEvaluator::test_raw_pipe_init
		tests/test_metric.py::TestEvaluationcombined_evaluation::test_modules_from_string_poslabel
	)
	distutils-r1_src_test
}
