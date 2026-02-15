# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..14} )
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
KEYWORDS="~amd64 ~arm64"
IUSE="torch"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/fsspec[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/shellingham[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/typer[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		sci-ml/hf_xet[${PYTHON_USEDEP}]
		torch? (
			sci-ml/safetensors[${PYTHON_USEDEP}]
		)
	')
	torch? (
		sci-ml/caffe2[${PYTHON_SINGLE_USEDEP}]
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	)
"

BDEPEND="
	test? (
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
		dev-vcs/git-lfs
	)
"

EPYTEST_PLUGINS=( pytest-asyncio pytest-mock )

distutils_enable_tests pytest

src_test() {
	local EPYTEST_IGNORE=(
		tests/test_file_download.py
		tests/test_hf_api.py
		tests/test_oauth.py
		tests/test_snapshot_download.py
		tests/test_webhooks_server.py
	)

	local EPYTEST_DESELECT=(
		tests/test_inference_client.py::TestOpenAsMimeBytes
		tests/test_inference_client.py::TestHeadersAndCookies
		tests/test_inference_client.py::test_as_url_with_pil_image
		tests/test_xet_upload.py::TestXetUpload::test_upload_file
		tests/test_xet_upload.py::TestXetUpload::test_upload_file_with_bytesio
		tests/test_xet_upload.py::TestXetUpload::test_upload_file_with_byte_array
		tests/test_xet_upload.py::TestXetUpload::test_fallback_to_lfs_when_xet_not_available
		tests/test_xet_upload.py::TestXetUpload::test_upload_folder
		tests/test_xet_upload.py::TestXetUpload::test_upload_folder_create_pr
		tests/test_xet_upload.py::TestXetLargeUpload
		tests/test_xet_upload.py::TestXetE2E::test_hf_xet_with_token_refresher
		tests/test_cache_layout.py::CacheFileLayoutHfHubDownload::test_file_download_happens_once
		tests/test_cache_layout.py::CacheFileLayoutHfHubDownload::test_file_download_happens_once_intra_revision
		tests/test_cache_layout.py::CacheFileLayoutHfHubDownload::test_file_downloaded_in_cache
		tests/test_cache_layout.py::CacheFileLayoutHfHubDownload::test_file_downloaded_in_cache
		tests/test_cache_layout.py::CacheFileLayoutHfHubDownload::test_multiple_refs_for_same_file
		tests/test_cache_layout.py::CacheFileLayoutHfHubDownload::test_no_exist_file_is_cached
		tests/test_cache_layout.py::CacheFileLayoutHfHubDownload::test_no_exist_file_is_cached
		tests/test_cache_layout.py::CacheFileLayoutSnapshotDownload
		tests/test_cache_layout.py::ReferenceUpdates::test_update_reference
		tests/test_cache_no_symlinks.py::TestCacheLayoutIfSymlinksNotSupported::test_download_no_symlink_existing_file
		tests/test_cache_no_symlinks.py::TestCacheLayoutIfSymlinksNotSupported::test_download_no_symlink_new_file
		tests/test_cache_no_symlinks.py::TestCacheLayoutIfSymlinksNotSupported::test_scan_and_delete_cache_no_symlinks
		tests/test_commit_scheduler.py::TestCommitScheduler::test_context_manager
		tests/test_commit_scheduler.py::TestCommitScheduler::test_missing_folder_is_created
		tests/test_commit_scheduler.py::TestCommitScheduler::test_mocked_push_to_hub
		tests/test_commit_scheduler.py::TestCommitScheduler::test_sync_and_squash_history
		tests/test_commit_scheduler.py::TestCommitScheduler::test_sync_local_folder
		tests/test_hf_file_system.py::HfFileSystemTests
		tests/test_hf_file_system.py::test_access_repositories_lists[foo]
		tests/test_hf_file_system.py::test_access_repositories_lists[datasets/foo]
		tests/test_hf_file_system.py::test_exists_after_repo_deletion
		tests/test_hf_file_system.py::test_hf_file_system_file_can_handle_gzipped_file
		tests/test_hub_mixin.py::HubMixinTest::test_from_pretrained_model_id_and_revision
		tests/test_hub_mixin.py::HubMixinTest::test_from_pretrained_model_id_only
		tests/test_hub_mixin.py::HubMixinTest::test_push_to_hub
		tests/test_hub_mixin_pytorch.py::PytorchHubMixinTest::test_from_pretrained_model_id_and_revision
		tests/test_hub_mixin_pytorch.py::PytorchHubMixinTest::test_from_pretrained_model_id_only
		tests/test_hub_mixin_pytorch.py::PytorchHubMixinTest::test_push_to_hub
		tests/test_inference_async_client.py::test_async_generate_timeout_error
		tests/test_inference_providers.py::TestHFInferenceProvider::test_prepare_mapping_info_unknown_task
		tests/test_offline_utils.py::test_offline_with_timeout
		tests/test_repocard.py::test_load_from_hub_if_repo_id_or_path_is_a_dir
		tests/test_repocard.py::RepocardMetadataUpdateTest
		tests/test_repocard.py::TestMetadataUpdateOnMissingCard
		tests/test_repocard.py::RepoCardTest::test_push_and_create_pr
		tests/test_repocard.py::RepoCardTest::test_push_to_hub
		tests/test_repocard.py::RepoCardTest::test_validate_repocard
		tests/test_repocard.py::SpaceCardTest::test_load_spacecard_from_hub
		tests/test_utils_cache.py::TestValidCacheUtils::test_scan_cache_on_valid_cache_unix
		tests/test_utils_cache.py::TestCorruptedCacheUtils
		tests/test_utils_http.py::TestUniqueRequestId
		tests/test_utils_http.py::test_client_get_request
		tests/test_utils_http.py::test_async_client_get_request
		tests/test_utils_pagination.py::TestPagination::test_paginate_hf_api
		tests/test_utils_telemetry.py::TestSendTelemetry::test_topic_multiple
		tests/test_utils_telemetry.py::TestSendTelemetry::test_topic_normal
		tests/test_utils_telemetry.py::TestSendTelemetry::test_topic_quoted
		tests/test_utils_telemetry.py::TestSendTelemetry::test_topic_with_subtopic
		tests/test_xet_download.py::TestXetFileDownload::test_get_xet_file_metadata_basic
		tests/test_xet_download.py::TestXetFileDownload::test_basic_download
		tests/test_xet_download.py::TestXetFileDownload::test_try_to_load_from_cache
		tests/test_xet_download.py::TestXetFileDownload::test_cache_reuse
		tests/test_xet_download.py::TestXetFileDownload::test_download_to_local_dir
		tests/test_xet_download.py::TestXetFileDownload::test_force_download
		tests/test_xet_download.py::TestXetSnapshotDownload
	)

	distutils-r1_src_test
}
