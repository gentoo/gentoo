# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="State-of-the-art Machine Learning for JAX, PyTorch and TensorFlow"
HOMEPAGE="
	https://pypi.org/project/transformers/
	https://huggingface.co/
"
SRC_URI="https://github.com/huggingface/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="torch"
RESTRICT="test" # Need network, too long to execute

RDEPEND="
	sci-ml/huggingface_hub[${PYTHON_SINGLE_USEDEP}]
	=sci-ml/tokenizers-0.21*[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/regex[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		sci-ml/safetensors[${PYTHON_USEDEP}]
	')
	torch? (
		sci-ml/accelerate[${PYTHON_SINGLE_USEDEP}]
		sci-ml/caffe2[${PYTHON_SINGLE_USEDEP}]
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	)
"

distutils_enable_tests import-check
