# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Mock library for boto"
HOMEPAGE="
	https://github.com/getmoto/moto/
	https://pypi.org/project/moto/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/aws-xray-sdk-0.93[${PYTHON_USEDEP}]
	>=dev-python/cfn-lint-0.40.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-3.3.1[${PYTHON_USEDEP}]
	dev-python/cookies[${PYTHON_USEDEP}]
	>=dev-python/docker-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/idna-2.5[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.10.1[${PYTHON_USEDEP}]
	>=dev-python/jsondiff-1.1.2[${PYTHON_USEDEP}]
	dev-python/boto3[${PYTHON_USEDEP}]
	dev-python/botocore[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-cors[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.0.7[${PYTHON_USEDEP}]
	>=dev-python/openapi-spec-validator-0.5.0[${PYTHON_USEDEP}]
	dev-python/pyaml[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/python-jose[${PYTHON_USEDEP}]
	>=dev-python/responses-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.5[${PYTHON_USEDEP}]
	dev-python/sshpubkeys[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	dev-python/zipp[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		>=dev-python/sure-1.4.11[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		tests/test_firehose/test_firehose_put.py::test_put_record_http_destination
		tests/test_firehose/test_firehose_put.py::test_put_record_batch_http_destination
		# broken code (local variable used referenced before definition)
		tests/test_appsync/test_appsync_schema.py
		# Needs network (or docker?) but not marked as such, bug #807031
		# TODO: report upstream
		tests/test_awslambda/test_lambda_layers_invoked.py::test_invoke_local_lambda_layers
		tests/test_batch/test_batch_jobs.py::test_cancel_pending_job
		tests/test_batch/test_batch_jobs.py::test_cancel_running_job
		tests/test_batch/test_batch_jobs.py::test_container_overrides
		tests/test_batch/test_batch_jobs.py::test_dependencies
		tests/test_batch/test_batch_jobs.py::test_failed_dependencies
		tests/test_batch/test_batch_jobs.py::test_failed_job
		tests/test_batch/test_batch_jobs.py::test_submit_job_array_size
		tests/test_batch/test_batch_jobs.py::test_terminate_job
		tests/test_batch/test_batch_jobs.py::test_terminate_nonexisting_job
		tests/test_cloudformation/test_cloudformation_custom_resources.py::test_create_custom_lambda_resource__verify_cfnresponse_failed

		tests/test_cloudformation/test_cloudformation_stack_integration.py::test_lambda_function
		tests/test_core/test_docker.py::test_docker_is_running_and_available
		tests/test_core/test_responses_module.py::TestResponsesMockWithPassThru::test_aws_and_http_requests
		tests/test_core/test_responses_module.py::TestResponsesMockWithPassThru::test_http_requests
		tests/test_events/test_events_lambdatriggers_integration.py::test_creating_bucket__invokes_lambda
		"tests/test_s3/test_s3_lambda_integration.py::test_objectcreated_put__invokes_lambda[match_events0-ObjectCreated:Put]"
		"tests/test_s3/test_s3_lambda_integration.py::test_objectcreated_put__invokes_lambda[match_events1-ObjectCreated:Put]"
		"tests/test_s3/test_s3_lambda_integration.py::test_objectcreated_put__invokes_lambda[match_events3-ObjectCreated:Put]"
		# TODO
		tests/test_sqs/test_sqs_integration.py::test_invoke_function_from_sqs_queue
		tests/test_sqs/test_sqs_integration.py::test_invoke_function_from_sqs_fifo_queue
		# require py_partiql_parser
		tests/test_s3/test_s3_select.py
		tests/test_dynamodb/test_dynamodb_statements.py
		# broken by new urllib3
		tests/test_moto_api/recorder/test_recorder.py::TestRecorder::test_s3_upload_data
		tests/test_moto_api/recorder/test_recorder.py::TestRecorder::test_s3_upload_file_using_requests
		tests/test_s3/test_s3.py::test_upload_from_file_to_presigned_url
		tests/test_s3/test_s3.py::test_put_chunked_with_v4_signature_in_body
		tests/test_s3/test_s3.py::test_presigned_put_url_with_approved_headers
		tests/test_s3/test_s3.py::test_presigned_put_url_with_custom_headers
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x TZ=UTC

	local serial_tests=(
		# these tests set up credentials that are needed by the tests below
		tests/test_core/test_importorder.py
		# these tests apparently rely on some other test setting credentials
		# up for them, so they need to be run separately, after the above
		tests/test_dynamodb/exceptions/test_dynamodb_exceptions.py
		tests/test_dynamodb/exceptions/test_dynamodb_transactions.py::test_transaction_with_empty_key
		tests/test_dynamodb/test_dynamodb.py::test_transact_write_items_put_conditional_expressions
		tests/test_dynamodb/test_dynamodb.py::test_transact_write_items_failure__return_item
		tests/test_lakeformation/test_resource_tags_integration.py
		tests/test_redshiftdata
		tests/test_resourcegroupstaggingapi/test_server.py::test_resourcegroupstaggingapi_list
		tests/test_s3/test_s3.py::test_delete_bucket_cors
		tests/test_s3/test_s3.py::test_delete_objects_percent_encoded
		tests/test_s3/test_s3.py::test_delete_versioned_bucket_returns_metadata
		tests/test_s3/test_s3_file_handles.py::TestS3FileHandleClosuresUsingMocks
		tests/test_s3control/test_s3control_access_points.py::test_delete_access_point
		tests/test_utilities/test_threaded_server.py::TestThreadedMotoServer::test_server_can_handle_multiple_services
	)

	EPYTEST_XDIST= epytest "${serial_tests[@]}"

	EPYTEST_DESELECT+=( "${serial_tests[@]}" )
	epytest -m 'not network'
}
