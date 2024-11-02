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
KEYWORDS="amd64 arm64 ~riscv ~x86"

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
	dev-python/jsonpath-ng[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
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
		dev-python/antlr4-python3-runtime[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
	)
"

: "${EPYTEST_TIMEOUT:=180}"
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Needs network (or docker?) but not marked as such, bug #807031
		# TODO: report upstream
		tests/test_core/test_request_passthrough.py
		tests/test_core/test_responses_module.py::TestResponsesMockWithPassThru::test_aws_and_http_requests
		tests/test_core/test_responses_module.py::TestResponsesMockWithPassThru::test_http_requests
		# broken code? (local variable used referenced before definition)
		tests/test_appsync/test_appsync_schema.py
		# require py_partiql_parser
		tests/test_s3/test_s3_select.py
		tests/test_dynamodb/test_dynamodb_statements.py
		# require joserfc
		tests/test_apigateway/test_apigateway.py::test_update_authorizer_configuration
		tests/test_apigateway/test_apigateway.py::test_create_authorizer
		tests/test_apigateway/test_apigateway.py::test_delete_authorizer
		tests/test_cognitoidp/test_cognitoidp_exceptions.py::TestCognitoUserDeleter::test_authenticate_with_signed_out_user
		tests/test_cognitoidp/test_cognitoidp_exceptions.py::TestCognitoUserPoolDuplidateEmails::test_use_existing_email__when_email_is_
		tests/test_cognitoidp/test_cognitoidp_exceptions.py::TestCognitoUserPoolDuplidateEmails::test_use_existing_email__when_username_
		tests/test_cognitoidp/test_cognitoidp_replay.py::TestCreateUserPoolWithPredeterminedID::test_different_seed
		tests/test_cognitoidp/test_cognitoidp_replay.py::TestCreateUserPoolWithPredeterminedID::test_same_seed
		tests/test_cognitoidp/test_server.py::test_sign_up_user_without_authentication
		tests/test_cognitoidp/test_server.py::test_admin_create_user_without_authentication
		# TODO
		tests/test_dynamodb/test_dynamodb_import_table.py
		tests/test_firehose/test_firehose_put.py::test_put_record_http_destination
		tests/test_firehose/test_firehose_put.py::test_put_record_batch_http_destination
		tests/test_stepfunctions/parser/test_stepfunctions_dynamodb_integration.py::test_zero_retry
	)
	local EPYTEST_IGNORE=(
		# require joserfc
		tests/test_cognitoidp/test_cognitoidp.py
	)

	case ${EPYTHON} in
		python3.13)
			EPYTEST_DESELECT+=(
				# suddenly started crashing, *shrug*
				tests/test_xray/test_xray_client.py::test_xray_context_patched
				tests/test_xray/test_xray_client.py::test_xray_dynamo_request_id
				tests/test_xray/test_xray_client.py::test_xray_dynamo_request_id_with_context_mgr
				tests/test_xray/test_xray_client.py::test_xray_udp_emitter_patched
			)
			;;
	esac

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

	rm -rf moto || die
	epytest -m 'not network and not requires_docker' \
		-p rerunfailures --reruns=5
}
