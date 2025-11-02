# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

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
	>=dev-python/botocore-1.35.47[${PYTHON_USEDEP}]
	>=dev-python/cfn-lint-0.40.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-35.0.0[${PYTHON_USEDEP}]
	dev-python/cookies[${PYTHON_USEDEP}]
	>=dev-python/docker-3.0.0[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-cors[${PYTHON_USEDEP}]
	>=dev-python/idna-2.5[${PYTHON_USEDEP}]
	>=dev-python/jinja2-2.10.1[${PYTHON_USEDEP}]
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
	>=dev-python/responses-0.25.6[${PYTHON_USEDEP}]
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
	)
"

EPYTEST_PLUGINS=( pytest-rerunfailures )
: "${EPYTEST_TIMEOUT:=180}"
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		tests/test_dynamodb/test_dynamodb_import_table.py
		# require joserfc
		tests/test_apigateway/test_apigateway.py::test_create_authorizer
		tests/test_apigateway/test_apigateway.py::test_delete_authorizer
		tests/test_apigateway/test_apigateway.py::test_update_authorizer_configuration
		tests/test_cognitoidp/test_cognitoidp_exceptions.py::TestCognitoUserDeleter::test_authenticate_with_signed_out_user
		tests/test_cognitoidp/test_cognitoidp_exceptions.py::TestCognitoUserPoolDuplidateEmails::test_use_existing_email__when_email_is_
		tests/test_cognitoidp/test_cognitoidp_exceptions.py::TestCognitoUserPoolDuplidateEmails::test_use_existing_email__when_username_
		tests/test_cognitoidp/test_cognitoidp_replay.py::TestCreateUserPoolWithPredeterminedID::test_different_seed
		tests/test_cognitoidp/test_cognitoidp_replay.py::TestCreateUserPoolWithPredeterminedID::test_same_seed
		tests/test_cognitoidp/test_server.py::test_admin_create_user_without_authentication
		tests/test_cognitoidp/test_server.py::test_associate_software_token
		tests/test_cognitoidp/test_server.py::test_sign_up_user_without_authentication
		# require py_partiql_parser
		tests/test_dynamodb/test_dynamodb_statements.py
		tests/test_s3/test_s3_select.py
		# require graphql
		tests/test_appsync/test_appsync_schema.py
		# Internet
		tests/test_core/test_request_passthrough.py::test_passthrough_calls_for_entire_service
		tests/test_core/test_request_passthrough.py::test_passthrough_calls_for_specific_url
		tests/test_core/test_request_passthrough.py::test_passthrough_calls_for_wildcard_urls
		tests/test_firehose/test_firehose_put.py::test_put_record_http_destination
		tests/test_firehose/test_firehose_put.py::test_put_record_batch_http_destination
	)
	local EPYTEST_IGNORE=(
		# require joserfc
		tests/test_cognitoidp/test_cognitoidp.py
	)

	if ! tc-has-64bit-time_t; then
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

	local -x TZ=UTC
	local -x AWS_DEFAULT_REGION=us-east-1

	rm -rf moto || die
	epytest -m 'not network and not requires_docker' --reruns=5
}
