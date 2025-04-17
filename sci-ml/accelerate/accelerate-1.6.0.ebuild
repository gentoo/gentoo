# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="Run your *raw* PyTorch training script on any kind of device"
HOMEPAGE="https://github.com/huggingface/accelerate"
SRC_URI="https://github.com/huggingface/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	sci-ml/huggingface_hub[${PYTHON_SINGLE_USEDEP}]
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		sci-ml/safetensors[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"
BDEPEND="test? (
	sci-ml/caffe2[gloo]
)"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		tests/test_examples.py
		tests/deepspeed
		tests/test_big_modeling.py
		tests/fsdp
		tests/tp
		tests/test_cli.py
	)
	local EPYTEST_DESELECT=(
		tests/test_modeling_utils.py::ModelingUtilsTester::test_infer_auto_device_map_with_buffer_check
		tests/test_modeling_utils.py::ModelingUtilsTester::test_infer_auto_device_map_with_buffer_check_and_multi_devices
		tests/test_modeling_utils.py::ModelingUtilsTester::test_infer_auto_device_map_with_fallback_allocation_and_buffers
		tests/test_utils.py::UtilsTester::test_patch_environment_key_exists
	)
	epytest tests
}
