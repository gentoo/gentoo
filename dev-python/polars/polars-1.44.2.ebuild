# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"
RUST_MIN_VER="1.95"

declare -A GIT_CRATES=(
	[color-backtrace]='https://github.com/orlp/color-backtrace;20f5eea183563bb4cfac9a4d65901d4a1002cde2;color-backtrace-%commit%'
	[object_store]='https://github.com/apache/arrow-rs-object-store;b07471e2bc341278f86e30cf80a850d56cbe2c67;arrow-rs-object-store-%commit%'
	[tikv-jemalloc-sys]='https://github.com/pola-rs/jemallocator;0d683dfb157097e2075d5e0eaf25f71f514a7552;jemallocator-%commit%/jemalloc-sys'
)

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit cargo distutils-r1

MY_P=polars-py-${PV}
DESCRIPTION="Extremely fast Query Engine for DataFrames, written in Rust"
HOMEPAGE="
	https://github.com/pola-rs/polars/
	https://pypi.org/project/polars/
"
SRC_URI="
	https://github.com/pola-rs/polars/archive/refs/tags/py-${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
	https://github.com/gentoo-crate-dist/polars/releases/download/py-${PV}/${MY_P}-crates.tar.xz
	${CARGO_CRATE_URIS}
"
S=${WORKDIR}/${MY_P}/py-polars

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD Boost-1.0
	CDLA-Permissive-2.0 ISC MIT Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-arch/lz4:=
	app-arch/zstd:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/maturin[${PYTHON_USEDEP}]
	test? (
		dev-python/aiosqlite[${PYTHON_USEDEP}]
		dev-python/boto3[${PYTHON_USEDEP}]
		dev-python/cloudpickle[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/flask-cors[${PYTHON_USEDEP}]
		dev-python/fsspec[${PYTHON_USEDEP}]
		dev-python/greenlet[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/moto[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/openpyxl[${PYTHON_USEDEP}]
		dev-python/orjson[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pyarrow[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/xlsxwriter[${PYTHON_USEDEP}]
		dev-python/zstandard[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( hypothesis )
EPYTEST_XDIST=1
distutils_enable_tests pytest

DOCS=( ../README.md )

src_prepare() {
	distutils-r1_src_prepare

	# ofc upstream must be patching crates
	local crate
	for crate in "${!GIT_CRATES[@]}"; do
		local override=$(
			grep "^${crate} =" "${ECARGO_HOME}"/config.toml || die
		)
		sed -i -e "s@^${crate} = { git.*\$@${override}@" ../Cargo.toml || die
	done

	# https://github.com/10XGenomics/lz4-rs/pull/39
	pushd "${ECARGO_VENDOR}"/lz4-sys* >/dev/null || Die
	eapply -p2 "${FILESDIR}/lz4-sys-unbundle-lz4.patch"
	popd >/dev/null || die

	export ZSTD_SYS_USE_PKG_CONFIG=1
}

rust_compile() {
	local DISTUTILS_USE_PEP517=maturin
	local DISTUTILS_ARGS=(
		# default features include requiring nightly Rust
		# full include fast_alloc which requires jemalloc which requires
		# git submodule dance
		--no-default-features
		--features=full_functionality
	)

	# TODO: other variants?
	pushd runtime/polars-runtime-32 >/dev/null || die
	distutils-r1_python_compile
	popd || die
}

python_compile() {
	rust_compile
	distutils-r1_python_compile
}

python_test() {
	local EPYTEST_IGNORE=(
		# altair
		tests/unit/operations/namespaces/test_plot.py
		# deltalake
		tests/unit/io/test_delta.py
		tests/unit/io/test_delta_deletion_vector.py
		# iceberg
		tests/unit/io/test_iceberg.py
		# jax
		tests/unit/ml/test_to_jax.py
		# torch
		tests/unit/ml/test_torch.py
		# polars_ds
		tests/unit/interop/test_ds_plugin.py
	)
	local EPYTEST_DESELECT=(
		# TODO
		'tests/docs/test_user_guide.py::test_run_python_snippets[path15]'
		'tests/unit/operations/map/test_inefficient_map_warning.py::test_parse_apply_functions[b-lambda x: str(x).title()-pl.col("b").cast(pl.String).str.to_titlecase()-None]'
		"tests/unit/operations/map/test_inefficient_map_warning.py::test_parse_apply_functions[b-lambda x: x.lower() + \":\" + x.upper() + \":\" + x.title()-(((pl.col(\"b\").str.to_lowercase() + ':') + pl.col(\"b\").str.to_uppercase()) + ':') + pl.col(\"b\").str.to_titlecase()-None]"
		tests/unit/operations/namespaces/string/test_string.py::test_titlecase
		tests/unit/sql/test_strings.py::test_string_case
		tests/unit/utils/test_utils.py::test_in_notebook
		# numba
		'tests/docs/test_user_guide.py::test_run_python_snippets[path17]'
		# great_tables
		'tests/docs/test_user_guide.py::test_run_python_snippets[path39]'
		# pytest.raises() on warnings
		tests/unit/expr/test_exprs.py::test_validate_format_argument_raises_chrono_format_warning
		tests/unit/lazyframe/test_lazyframe.py::test_lazyframe_membership_operator
		tests/unit/lazyframe/test_show_graph.py::test_show_graph_plan_stage_default_changed
		tests/unit/meta/test_api.py::test_namespace_warning_on_override
		# azure
		'tests/unit/io/cloud/test_credential_provider.py::test_credential_provider_rebuild_clears_cache[CredentialProviderAzure-abfss://container@storage_account.dfs.core.windows.net/bucket-initial_credentials1-updated_credentials1]'
		# Internet
		tests/unit/io/cloud/test_credential_provider.py::test_credential_provider_serialization_custom_provider
		tests/unit/io/test_csv.py::test_read_web_file
		# connectorx
		'tests/unit/io/database/test_read.py::test_read_database[uri: connectorx]'
		tests/unit/io/database/test_read.py::test_read_database_cx_credentials
		# adbc_driver_sqlite
		'tests/unit/io/database/test_read.py::test_read_database[conn: adbc (batched)]'
		'tests/unit/io/database/test_read.py::test_read_database[conn: adbc (fetchall)]'
		'tests/unit/io/database/test_read.py::test_read_database[uri: adbc]'
		'tests/unit/io/database/test_read.py::test_read_database_iter_batches[conn: adbc (ignore batch_size)]'
		'tests/unit/io/database/test_read.py::test_read_database_iter_batches[conn: adbc]'
		'tests/unit/io/database/test_read.py::test_read_database_mocked[adbc_driver_postgresql-75000-False-fetch_arrow]'
		'tests/unit/io/database/test_read.py::test_read_database_mocked[adbc_driver_postgresql-75000-True-fetch_record_batch]'
		'tests/unit/io/database/test_read.py::test_read_database_mocked[adbc_driver_postgresql-None-False-fetch_arrow]'
		'tests/unit/io/database/test_read.py::test_read_database_parameterised_adbc[?-param_value2]'
		'tests/unit/io/database/test_read.py::test_read_database_parameterised_adbc[?-param_value3]'
		'tests/unit/io/database/test_read.py::test_read_database_parameterised_adbc[?-param_value4]'
		'tests/unit/io/database/test_read.py::test_read_database_parameterised_adbc[?-param_value5]'
		'tests/unit/io/database/test_read.py::test_read_database_parameterised_adbc[?-param_value6]'
		'tests/unit/io/database/test_read.py::test_read_database_parameterised_multiple_adbc[params1-param_value1]'
		'tests/unit/io/database/test_read.py::test_read_database_parameterised_multiple_adbc[params2-param_value2]'
		'tests/unit/io/database/test_read.py::test_read_database_parameterised_multiple_adbc[params3-param_value3]'
		'tests/unit/io/database/test_read.py::test_read_database_parameterised_multiple_adbc[params4-param_value4]'
		'tests/unit/io/database/test_read.py::test_read_database_parameterised_multiple_adbc[params5-param_value5]'
		'tests/unit/io/database/test_read.py::test_read_database_uri_parameterised[?-param_value2]'
		'tests/unit/io/database/test_read.py::test_read_database_uri_parameterised[?-param_value3]'
		'tests/unit/io/database/test_read.py::test_read_database_uri_parameterised[?-param_value4]'
		'tests/unit/io/database/test_read.py::test_read_database_uri_parameterised[?-param_value5]'
		'tests/unit/io/database/test_read.py::test_read_database_uri_parameterised[?-param_value6]'
		'tests/unit/io/database/test_read.py::test_read_database_uri_parameterised_multiple[params1-param_value1]'
		'tests/unit/io/database/test_read.py::test_read_database_uri_parameterised_multiple[params2-param_value2]'
		'tests/unit/io/database/test_read.py::test_read_database_uri_parameterised_multiple[params3-param_value3]'
		'tests/unit/io/database/test_read.py::test_read_database_uri_parameterised_multiple[params4-param_value4]'
		'tests/unit/io/database/test_read.py::test_read_database_uri_parameterised_multiple[params5-param_value5]'
		'tests/unit/io/database/test_write.py::TestWriteDatabase::test_write_database_append_replace[adbc-False]'
		'tests/unit/io/database/test_write.py::TestWriteDatabase::test_write_database_append_replace[adbc-True]'
		'tests/unit/io/database/test_write.py::TestWriteDatabase::test_write_database_create[adbc-False]'
		'tests/unit/io/database/test_write.py::TestWriteDatabase::test_write_database_create[adbc-True]'
		'tests/unit/io/database/test_write.py::TestWriteDatabase::test_write_database_create_quoted_tablename[adbc-False]'
		'tests/unit/io/database/test_write.py::TestWriteDatabase::test_write_database_create_quoted_tablename[adbc-True]'
		'tests/unit/io/database/test_write.py::TestWriteDatabase::test_write_database_errors[adbc-False]'
		'tests/unit/io/database/test_write.py::TestWriteDatabase::test_write_database_errors[adbc-True]'
		tests/unit/io/database/test_write.py::test_write_database_adbc_temporary_table
		# deltalake
		tests/unit/io/test_hive.py::test_hive_decode_reserved_ascii_23241
		tests/unit/io/test_hive.py::test_hive_decode_utf8_23241
		# fastexcel, xlsx2csv
		'tests/unit/io/test_spreadsheet.py::test_drop_empty_rows[calamine]'
		'tests/unit/io/test_spreadsheet.py::test_drop_empty_rows[xlsx2csv]'
		'tests/unit/io/test_spreadsheet.py::test_excel_empty_sheet'
		'tests/unit/io/test_spreadsheet.py::test_excel_freeze_panes'
		'tests/unit/io/test_spreadsheet.py::test_excel_hidden_columns'
		'tests/unit/io/test_spreadsheet.py::test_excel_mixed_calamine_float_data'
		'tests/unit/io/test_spreadsheet.py::test_excel_read_columns_nonlist_sequence[calamine]'
		'tests/unit/io/test_spreadsheet.py::test_excel_read_columns_nonlist_sequence[xlsx2csv]'
		'tests/unit/io/test_spreadsheet.py::test_excel_read_named_table_with_total_row'
		'tests/unit/io/test_spreadsheet.py::test_excel_read_no_headers[calamine]'
		'tests/unit/io/test_spreadsheet.py::test_excel_read_no_headers[xlsx2csv]'
		'tests/unit/io/test_spreadsheet.py::test_excel_round_trip'
		'tests/unit/io/test_spreadsheet.py::test_excel_type_inference_with_nulls[calamine]'
		'tests/unit/io/test_spreadsheet.py::test_excel_type_inference_with_nulls[xlsx2csv]'
		'tests/unit/io/test_spreadsheet.py::test_excel_write_column_and_row_totals'
		'tests/unit/io/test_spreadsheet.py::test_excel_write_compound_types[calamine-list_dtype0]'
		'tests/unit/io/test_spreadsheet.py::test_excel_write_compound_types[xlsx2csv-list_dtype2]'
		'tests/unit/io/test_spreadsheet.py::test_excel_write_multiple_tables'
		'tests/unit/io/test_spreadsheet.py::test_excel_write_sparklines[calamine]'
		'tests/unit/io/test_spreadsheet.py::test_excel_write_sparklines[xlsx2csv]'
		'tests/unit/io/test_spreadsheet.py::test_excel_write_to_bytesio[calamine]'
		'tests/unit/io/test_spreadsheet.py::test_excel_write_to_bytesio[xlsx2csv]'
		'tests/unit/io/test_spreadsheet.py::test_excel_write_to_file_object[calamine]'
		'tests/unit/io/test_spreadsheet.py::test_excel_write_to_file_object[xlsx2csv]'
		'tests/unit/io/test_spreadsheet.py::test_excel_write_worksheet_object'
		'tests/unit/io/test_spreadsheet.py::test_read_dropped_cols[read_excel-path_xlsx-params0]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_all_sheets[read_excel-path_xls-params0]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_all_sheets[read_excel-path_xlsb-params4]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_all_sheets[read_excel-path_xlsx-params1]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_all_sheets[read_excel-path_xlsx-params3]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_all_sheets[read_ods-path_ods-params5]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_all_sheets_with_sheet_name[calamine]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_all_sheets_with_sheet_name[xlsx2csv]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_basic_datatypes[calamine]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_basic_datatypes[xlsx2csv]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_multiple_workbooks[read_excel-path_xls-params0]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_multiple_workbooks[read_excel-path_xlsb-params4]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_multiple_workbooks[read_excel-path_xlsx-params1]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_multiple_workbooks[read_excel-path_xlsx-params3]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_multiple_workbooks[read_ods-path_ods-params5]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_multiple_worksheets[read_excel-path_xls-params0]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_multiple_worksheets[read_excel-path_xlsb-params4]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_multiple_worksheets[read_excel-path_xlsx-params1]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_multiple_worksheets[read_excel-path_xlsx-params3]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_multiple_worksheets[read_ods-path_ods-params5]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_temporal_data[path_xls-params0]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_temporal_data[path_xlsb-params3]'
		'tests/unit/io/test_spreadsheet.py::test_read_excel_temporal_data[path_xlsx-params1]'
		'tests/unit/io/test_spreadsheet.py::test_read_invalid_worksheet[read_excel-path_xls-params0]'
		'tests/unit/io/test_spreadsheet.py::test_read_invalid_worksheet[read_excel-path_xlsb-params4]'
		'tests/unit/io/test_spreadsheet.py::test_read_invalid_worksheet[read_excel-path_xlsx-params1]'
		'tests/unit/io/test_spreadsheet.py::test_read_invalid_worksheet[read_excel-path_xlsx-params3]'
		'tests/unit/io/test_spreadsheet.py::test_read_invalid_worksheet[read_ods-path_ods-params5]'
		'tests/unit/io/test_spreadsheet.py::test_read_mixed_dtype_columns[read_ods-path_ods_mixed-additional_params1]'
		'tests/unit/io/test_spreadsheet.py::test_read_spreadsheet[read_excel-path_xls-engine_params0]'
		'tests/unit/io/test_spreadsheet.py::test_read_spreadsheet[read_excel-path_xlsb-engine_params4]'
		'tests/unit/io/test_spreadsheet.py::test_read_spreadsheet[read_excel-path_xlsx-engine_params1]'
		'tests/unit/io/test_spreadsheet.py::test_read_spreadsheet[read_excel-path_xlsx-engine_params3]'
		'tests/unit/io/test_spreadsheet.py::test_read_spreadsheet[read_ods-path_ods-engine_params5]'
		'tests/unit/io/test_spreadsheet.py::test_schema_overrides'
		'tests/unit/io/test_spreadsheet.py::test_spreadsheet_no_resource_warning[read_excel-path_xlsx-params0]'
		'tests/unit/io/test_spreadsheet.py::test_spreadsheet_no_resource_warning[read_excel-path_xlsx-params2]'
		'tests/unit/io/test_spreadsheet.py::test_spreadsheet_no_resource_warning[read_ods-path_ods-params3]'
		# gevent
		tests/unit/lazyframe/test_async.py::test_gevent_collect_async_no_switch
		tests/unit/lazyframe/test_async.py::test_gevent_collect_async_spawn
		tests/unit/lazyframe/test_async.py::test_gevent_collect_async_switch
		tests/unit/lazyframe/test_async.py::test_gevent_collect_async_with_hub
		tests/unit/lazyframe/test_async.py::test_gevent_collect_async_without_hub
	)

	epytest -o addopts= -m "not benchmark"
}
