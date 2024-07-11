# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi toolchain-funcs

DESCRIPTION="Mock library for boto"
HOMEPAGE="
	https://github.com/getmoto/moto/
	https://pypi.org/project/moto/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/aws-xray-sdk-0.93[${PYTHON_USEDEP}]
	dev-python/boto3[${PYTHON_USEDEP}]
	>=dev-python/botocore-1.14.0[${PYTHON_USEDEP}]
	>=dev-python/cfn-lint-0.40.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-3.3.1[${PYTHON_USEDEP}]
	dev-python/cookies[${PYTHON_USEDEP}]
	>=dev-python/docker-3.0.0[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-cors[${PYTHON_USEDEP}]
	>=dev-python/idna-2.5[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.10.1[${PYTHON_USEDEP}]
	>=dev-python/jsondiff-1.1.2[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.0.7[${PYTHON_USEDEP}]
	>=dev-python/openapi-spec-validator-0.5.0[${PYTHON_USEDEP}]
	dev-python/pyaml[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/python-jose[${PYTHON_USEDEP}]
	>=dev-python/responses-0.15.0[${PYTHON_USEDEP}]
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
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_test() {
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
		tests/test_core/test_request_passthrough.py
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
		# require joserfc
		tests/test_apigateway/test_apigateway.py::test_update_authorizer_configuration
		tests/test_apigateway/test_apigateway.py::test_create_authorizer
		tests/test_apigateway/test_apigateway.py::test_delete_authorizer
		tests/test_cognitoidp/test_cognitoidp_exceptions.py::TestCognitoUserDeleter::test_authenticate_with_signed_out_user
		No
		tests/test_cognitoidp/test_cognitoidp_exceptions.py::TestCognitoUserPoolDuplidateEmails::test_use_existing_email__when_email_is_
		-
		tests/test_cognitoidp/test_cognitoidp_exceptions.py::TestCognitoUserPoolDuplidateEmails::test_use_existing_email__when_username_
		-
		tests/test_cognitoidp/test_cognitoidp_replay.py::TestCreateUserPoolWithPredeterminedID::test_different_seed
		No
		tests/test_cognitoidp/test_cognitoidp_replay.py::TestCreateUserPoolWithPredeterminedID::test_same_seed
		tests/test_cognitoidp/test_server.py::test_sign_up_user_without_authentication
		tests/test_cognitoidp/test_server.py::test_admin_create_user_without_authentication
		# TODO
		tests/test_dynamodb/test_dynamodb_import_table.py
		# hangs
		tests/test_core/test_account_id_resolution.py::TestAccountIdResolution::test_environment_variable_takes_precedence
	)
	local EPYTEST_IGNORE=(
		# require joserfc
		tests/test_cognitoidp/test_cognitoidp.py
		# require antlr4 (which doesn't support py3.12)
		tests/test_stepfunctions/parser
	)

	# test for 32-bit time_t
	"$(tc-getCC)" ${CFLAGS} ${CPPFLAGS} -c -x c - -o /dev/null <<-EOF &>/dev/null
		#include <sys/types.h>
		int test[sizeof(time_t) >= 8 ? 1 : -1];
	EOF

	if [[ ${?} -eq 0 ]]; then
		einfo "time_t is at least 64-bit long"
	else
		einfo "time_t is smaller than 64 bits, will skip broken tests"
		EPYTEST_DESELECT+=(
			tests/test_acm/test_acm.py::test_request_certificate_with_optional_arguments
			tests/test_s3/test_multiple_accounts_server.py::TestAccountIdResolution::test_with_custom_request_header
			tests/test_s3/test_server.py::test_s3_server_post_cors_multiple_origins
		)
		EPYTEST_IGNORE+=(
			tests/test_route53domains/test_route53domains_domain.py
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x TZ=UTC

	local serial_tests=(
		# these tests set up credentials that are needed by the tests below
		tests/test_core/test_importorder.py
		# these tests apparently rely on some other test setting credentials
		# up for them, so they need to be run separately, after the above
		tests/test_awslambda_simple/test_lambda_simple.py::test_run_function{,_no_log}
		tests/test_dynamodb/exceptions/test_dynamodb_exceptions.py
		tests/test_dynamodb/exceptions/test_dynamodb_transactions.py::test_transaction_with_empty_key
		tests/test_dynamodb/test_dynamodb.py::test_transact_write_items_failure__return_item
		tests/test_dynamodb/test_dynamodb.py::test_transact_write_items_put_conditional_expressions
		tests/test_dynamodb/test_dynamodb_update_expressions.py::test_update_different_map_elements_in_single_request
		tests/test_events/test_events.py::test_start_replay_send_to_log_group
		tests/test_lakeformation/test_resource_tags_integration.py
		tests/test_redshiftdata
		tests/test_resourcegroupstaggingapi/test_server.py::test_resourcegroupstaggingapi_list
		tests/test_s3/test_s3.py::test_delete_bucket_cors
		tests/test_s3/test_s3.py::test_delete_objects_percent_encoded
		tests/test_s3/test_s3.py::test_delete_versioned_bucket_returns_metadata
		tests/test_s3/test_s3_copyobject.py::test_copy_key_boto3_with_args
		tests/test_s3/test_s3_copyobject.py::test_copy_key_boto3_with_args__using_multipart
		tests/test_s3/test_s3_file_handles.py::TestS3FileHandleClosuresUsingMocks
		tests/test_s3/test_s3_list_object_versions.py
		tests/test_s3/test_s3_tagging.py
		tests/test_s3control/test_s3control_access_points.py::test_delete_access_point
		tests/test_utilities/test_threaded_server.py::TestThreadedMotoServer::test_server_can_handle_multiple_services
		tests/test_utilities/test_threaded_server.py::TestThreadedMotoServer::test_server_is_reachable
	)

	distutils-r1_src_test
}

python_test() {
	EPYTEST_XDIST= epytest "${serial_tests[@]}"

	local EPYTEST_DESELECT+=(
		"${EPYTEST_DESELECT[@]}"
		"${serial_tests[@]}"
	)
	case ${EPYTHON} in
		python3.13)
			EPYTEST_DESELECT+=(
				tests/test_ses/test_ses_boto3.py::test_send_raw_email
				tests/test_ses/test_ses_boto3.py::test_send_raw_email_validate_domain
				tests/test_ses/test_ses_boto3.py::test_send_raw_email_without_source
				tests/test_sesv2/test_sesv2.py::test_send_raw_email
				tests/test_sesv2/test_sesv2.py::test_send_raw_email__with_specific_message
				tests/test_sesv2/test_sesv2.py::test_send_raw_email__with_to_address_display_name
			)
			;;
	esac

	epytest -m 'not network'
}
