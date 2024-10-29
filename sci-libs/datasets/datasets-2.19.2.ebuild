# Copyright 2023-2024 Gentoo Authors
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

IUSE="test"

RDEPEND="
	${PYTHON_DEPS}
	sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
	sci-libs/caffe2[${PYTHON_SINGLE_USEDEP},numpy]
	$(python_gen_cond_dep '
		dev-python/absl-py[${PYTHON_USEDEP}]
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
		dev-python/scikit-learn[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/xxhash[${PYTHON_USEDEP}]
		dev-python/zstandard[${PYTHON_USEDEP}]
		sci-libs/huggingface_hub[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"
BDEPEND="test? (
	$(python_gen_cond_dep '
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/pytest-datadir[${PYTHON_USEDEP}]
		dev-python/decorator[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		sci-libs/jiwer[${PYTHON_USEDEP}]
		sci-libs/seqeval[${PYTHON_USEDEP}]
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
		tests/test_upstream_hub.py
		tests/packaged_modules/test_spark.py
		tests/test_load.py
	)

	local EPYTEST_DESELECT=(
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_filter_caching_on_disk"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_filter_in_memory"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_filter_on_disk"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_flatten_indices_in_memory"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_flatten_indices_on_disk"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_map_batched_in_memory"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_map_batched_on_disk"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_map_caching_on_disk"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_map_in_memory"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_map_on_disk"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_map_remove_columns_in_memory"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_map_remove_columns_on_disk"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_select_in_memory"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_select_on_disk"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_set_format_numpy_multiple_columns_in_memory"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_set_format_numpy_multiple_columns_on_disk"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_set_format_torch_in_memory"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_set_format_torch_on_disk"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_train_test_split_in_memory"
		"tests/test_arrow_dataset.py::BaseDatasetTest::test_train_test_split_on_disk"
		"tests/test_arrow_dataset.py::TaskTemplatesTest::test_task_automatic_speech_recognition"
		"tests/test_arrow_dataset.py::StratifiedTest::test_train_test_split_startify"
		"tests/test_arrow_dataset.py::test_dataset_format_with_unformatted_image"
		"tests/test_arrow_dataset.py::test_map_cases"
		"tests/test_dataset_dict.py::DatasetDictTest::test_set_format_numpy"
		"tests/test_dataset_dict.py::DatasetDictTest::test_set_format_torch"
		"tests/test_distributed.py::test_torch_distributed_run"
		"tests/test_distributed.py::test_torch_distributed_run_streaming_with_num_workers"
		"tests/test_file_utils.py::TestxPath::test_xpath_glob"
		"tests/test_file_utils.py::TestxPath::test_xpath_rglob"
		"tests/test_file_utils.py::test_xopen_remote"
		"tests/test_file_utils.py::test_xexists_private"
		"tests/test_file_utils.py::test_xlistdir_private"
		"tests/test_file_utils.py::test_xisdir_private"
		"tests/test_file_utils.py::test_xisfile_private"
		"tests/test_file_utils.py::test_xgetsize_private"
		"tests/test_file_utils.py::test_xglob_private"
		"tests/test_file_utils.py::test_xwalk_private"
		"tests/test_fingerprint.py::TokenizersHashTest::test_hash_regex"
		"tests/test_fingerprint.py::TokenizersHashTest::test_hash_tokenizer"
		"tests/test_fingerprint.py::TokenizersHashTest::test_hash_tokenizer_with_cache"
		"tests/test_fingerprint.py::RecurseHashTest::test_hash_ignores_line_definition_of_function"
		"tests/test_fingerprint.py::RecurseHashTest::test_hash_ipython_function"
		"tests/test_fingerprint.py::HashingTest::test_hash_torch_compiled_module"
		"tests/test_fingerprint.py::HashingTest::test_hash_torch_generator"
		"tests/test_fingerprint.py::HashingTest::test_hash_torch_tensor"
		"tests/test_fingerprint.py::HashingTest::test_set_doesnt_depend_on_order"
		"tests/test_fingerprint.py::HashingTest::test_set_stable"
		"tests/test_fingerprint.py::test_move_script_doesnt_change_hash"
		"tests/test_formatting.py::ArrowExtractorTest::test_numpy_extractor"
		"tests/test_formatting.py::ArrowExtractorTest::test_numpy_extractor_nested"
		"tests/test_formatting.py::ArrowExtractorTest::test_numpy_extractor_temporal"
		"tests/test_formatting.py::FormatterTest::test_numpy_formatter"
		"tests/test_formatting.py::FormatterTest::test_numpy_formatter_image"
		"tests/test_formatting.py::FormatterTest::test_numpy_formatter_np_array_kwargs"
		"tests/test_formatting.py::FormatterTest::test_torch_formatter"
		"tests/test_formatting.py::FormatterTest::test_torch_formatter_image"
		"tests/test_formatting.py::FormatterTest::test_torch_formatter_torch_tensor_kwargs"
		"tests/test_formatting.py::test_torch_formatter_sets_default_dtypes"
		"tests/test_inspect.py::test_get_dataset_config_names[hf-internal-testing/librispeech_asr_dummy-expected4]"
		"tests/test_inspect.py::test_get_dataset_default_config_name[hf-internal-testing/librispeech_asr_dummy-None]"
		"tests/test_inspect.py::test_inspect_dataset"
		"tests/test_inspect.py::test_inspect_metric"
		"tests/test_inspect.py::test_get_dataset_config_info"
		"tests/test_inspect.py::test_get_dataset_config_info_error[paws-None-ValueError]"
		"tests/test_inspect.py::test_get_dataset_config_names"
		"tests/test_inspect.py::test_get_dataset_default_config_name"
		"tests/test_inspect.py::test_get_dataset_info"
		"tests/test_inspect.py::test_get_dataset_split_names"
		"tests/test_inspect.py::test_get_dataset_config_info_private"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_bertscore"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_bleurt"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_chrf"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_code_eval"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_competition_math"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_coval"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_cuad"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_frugalscore"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_glue"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_google_bleu"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_indic_glue"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_mae"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_mauve"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_mean_iou"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_meteor"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_mse"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_precision"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_roc_auc"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_rouge"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_sacrebleu"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_sari"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_spearmanr"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_super_glue"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_ter"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_wiki_split"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_xnli"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_xtreme_s"
		"tests/test_metric_common.py::LocalMetricTest::test_load_metric_bleu"
		"tests/commands/test_test.py::test_test_command"
		"tests/features/test_array_xd.py::ExtensionTypeCompatibilityTest::test_array2d_nonspecific_shape"
		"tests/features/test_array_xd.py::ExtensionTypeCompatibilityTest::test_extension_indexing"
		"tests/features/test_array_xd.py::ExtensionTypeCompatibilityTest::test_multiple_extensions_same_row"
		"tests/features/test_array_xd.py::ArrayXDTest::test_from_dict_2d"
		"tests/features/test_array_xd.py::ArrayXDTest::test_from_dict_3d"
		"tests/features/test_array_xd.py::ArrayXDTest::test_from_dict_4d"
		"tests/features/test_array_xd.py::ArrayXDTest::test_from_dict_5d"
		"tests/features/test_array_xd.py::ArrayXDTest::test_write_2d"
		"tests/features/test_array_xd.py::ArrayXDTest::test_write_3d"
		"tests/features/test_array_xd.py::ArrayXDTest::test_write_4d"
		"tests/features/test_array_xd.py::ArrayXDTest::test_write_5d"
		"tests/features/test_array_xd.py::ArrayXDTest::test_write_batch_2d"
		"tests/features/test_array_xd.py::ArrayXDTest::test_write_batch_3d"
		"tests/features/test_array_xd.py::ArrayXDTest::test_write_batch_4d"
		"tests/features/test_array_xd.py::ArrayXDTest::test_write_batch_5d"
		"tests/features/test_array_xd.py::test_array_xd_numpy_arrow_extractor"
		"tests/features/test_array_xd.py::test_array_xd_with_none"
		"tests/features/test_array_xd.py::test_dataset_map"
		"tests/features/test_audio.py::test_audio_feature_encode_example"
		"tests/features/test_audio.py::test_audio_feature_encode_example_pcm"
		"tests/features/test_audio.py::test_audio_decode_example_pcm"
		"tests/features/test_audio.py::test_dataset_cast_to_audio_features"
		"tests/features/test_audio.py::test_dataset_concatenate_audio_features"
		"tests/features/test_audio.py::test_dataset_concatenate_nested_audio_features"
		"tests/features/test_audio.py::test_dataset_with_audio_feature_undecoded"
		"tests/features/test_audio.py::test_formatted_dataset_with_audio_feature_undecoded"
		"tests/features/test_audio.py::test_dataset_with_audio_feature_map_undecoded"
		"tests/features/test_image.py::test_formatted_dataset_with_image_feature_map"
		"tests/features/test_image.py::test_formatted_dataset_with_image_feature"
		"tests/features/test_image.py::test_formatted_dataset_with_image_feature_undecoded"
		"tests/packaged_modules/test_cache.py::test_cache_multi_configs"
		"tests/packaged_modules/test_cache.py::test_cache_single_config"
		"tests/packaged_modules/test_cache.py::test_cache_capital_letters"
		"tests/packaged_modules/test_folder_based_builder.py::test_data_files_with_different_levels_no_metadata"
		"tests/packaged_modules/test_folder_based_builder.py::test_data_files_with_one_label_no_metadata"
		"tests/test_data_files.py::test_DataFilesList_from_patterns_locally_with_extra_files"
		"tests/test_data_files.py::test_DataFilesDict_from_patterns_locally_or_remote_hashing"
		"tests/test_hf_gcp.py::TestDatasetOnHfGcp::test_dataset_info_available_natural_questions/default@19ba7767b174ad046a84f46af056517a3910ee57"
		"tests/test_hf_gcp.py::TestDatasetOnHfGcp::test_dataset_info_available_wiki40b/en@7b21a2e64b90323b2d3d1b81aa349bb4bc76d9bf"
		"tests/test_hf_gcp.py::TestDatasetOnHfGcp::test_dataset_info_available_wiki_dpr/psgs_w100.multiset.no_index@b24a417d802a583f8922946c1c75210290e93108"
		"tests/test_hf_gcp.py::TestDatasetOnHfGcp::test_dataset_info_available_wiki_dpr/psgs_w100.nq.compressed@b24a417d802a583f8922946c1c75210290e93108"
		"tests/test_hf_gcp.py::TestDatasetOnHfGcp::test_dataset_info_available_wiki_dpr/psgs_w100.nq.no_index@b24a417d802a583f8922946c1c75210290e93108"
		"tests/test_hf_gcp.py::TestDatasetOnHfGcp::test_dataset_info_available_wikipedia/20220301.de@4d013bdd32c475c8536aae00a56efc774f061649"
		"tests/test_hf_gcp.py::TestDatasetOnHfGcp::test_dataset_info_available_wikipedia/20220301.en@4d013bdd32c475c8536aae00a56efc774f061649"
		"tests/test_hf_gcp.py::TestDatasetOnHfGcp::test_dataset_info_available_wikipedia/20220301.fr@4d013bdd32c475c8536aae00a56efc774f061649"
		"tests/test_hf_gcp.py::TestDatasetOnHfGcp::test_dataset_info_available_wikipedia/20220301.frr@4d013bdd32c475c8536aae00a56efc774f061649"
		"tests/test_hf_gcp.py::TestDatasetOnHfGcp::test_dataset_info_available_wikipedia/20220301.it@4d013bdd32c475c8536aae00a56efc774f061649"
		"tests/test_hf_gcp.py::TestDatasetOnHfGcp::test_dataset_info_available_wikipedia/20220301.simple@4d013bdd32c475c8536aae00a56efc774f061649"
		"tests/test_hf_gcp.py::test_as_dataset_from_hf_gcs"
		"tests/test_hf_gcp.py::test_as_streaming_dataset_from_hf_gcs"
		"tests/test_iterable_dataset.py::test_iterable_dataset_from_hub_torch_dataloader_parallel"
		"tests/test_offline_util.py::test_offline_with_timeout"
		"tests/io/test_parquet.py::test_parquet_read_geoparquet"
	)
	distutils-r1_src_test
}
