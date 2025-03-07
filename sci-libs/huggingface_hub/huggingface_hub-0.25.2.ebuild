# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
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
	dev-python/filelock[${PYTHON_USEDEP}]
	dev-python/fsspec[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_test() {
	local EPYTEST_IGNORE=(
		contrib/sentence_transformers/test_sentence_transformers.py
		contrib/spacy/test_spacy.py
		contrib/timm/test_timm.py
		tests/test_command_delete_cache.py
		tests/test_inference_api.py
		tests/test_inference_async_client.py
		tests/test_inference_client.py
		tests/test_inference_text_generation.py
		tests/test_init_lazy_loading.py
		tests/test_cache_no_symlinks.py
		tests/test_file_download.py
		tests/test_hf_api.py
		tests/test_repocard.py
		tests/test_repository.py
		tests/test_snapshot_download.py
		tests/test_utils_cache.py
		tests/test_utils_telemetry.py
		tests/test_webhooks_server.py
	)

	local EPYTEST_DESELECT=(
		tests/test_cache_layout.py::ReferenceUpdates::test_update_reference
		tests/test_commit_scheduler.py::TestCommitScheduler::test_sync_local_folder
		tests/test_hub_mixin.py::HubMixinTest::test_push_to_hub
		tests/test_hub_mixin_pytorch.py::PytorchHubMixinTest::test_push_to_hub
	)

	distutils-r1_src_test
}
