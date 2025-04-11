# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="a client library to interact with the Hugging Face Hub"
HOMEPAGE="
	https://pypi.org/project/huggingface_hub/
"
SRC_URI="https://github.com/huggingface/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/fsspec[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
"

BDEPEND="test? (
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
		dev-vcs/git-lfs
	)"

distutils_enable_tests pytest

src_test() {
	local EPYTEST_IGNORE=(
		contrib
		tests/test_cache_layout.py
		tests/test_cache_no_symlinks.py
		tests/test_command_delete_cache.py
		tests/test_commit_scheduler.py
		tests/test_file_download.py
		tests/test_hf_api.py
		tests/test_hf_file_system.py
		tests/test_inference_api.py
		tests/test_inference_async_client.py
		tests/test_inference_client.py
		tests/test_inference_text_generation.py
		tests/test_repocard.py
		tests/test_repository.py
		tests/test_snapshot_download.py
		tests/test_utils_cache.py
		tests/test_utils_http.py
		tests/test_utils_telemetry.py
		tests/test_webhooks_server.py
	)

	local EPYTEST_DESELECT=(
		tests/test_dduf.py::TestExportFolder::test_export_folder
		tests/test_hub_mixin.py::HubMixinTest::test_push_to_hub
		tests/test_hub_mixin_pytorch.py::PytorchHubMixinTest::test_push_to_hub
		tests/test_offline_utils.py::test_offline_with_timeout
		tests/test_utils_pagination.py::TestPagination::test_paginate_github_api
		tests/test_fastai_integration.py::TestFastaiUtils::test_push_to_hub_and_from_pretrained_fastai
	)

	distutils-r1_src_test
}
