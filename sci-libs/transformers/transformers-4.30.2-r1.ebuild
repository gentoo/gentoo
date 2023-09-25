# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
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
RESTRICT="test" # Need some modules, not yet packaged

RDEPEND="
	dev-python/filelock[${PYTHON_USEDEP}]
	sci-libs/huggingface_hub[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	sci-libs/safetensors[${PYTHON_USEDEP}]
	sci-libs/tokenizers[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
