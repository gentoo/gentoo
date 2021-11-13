# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="Mock library for boto"
HOMEPAGE="https://github.com/spulec/moto"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-python/aws-xray-sdk-python-0.93[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/backports-tempfile[${PYTHON_USEDEP}]' python3_{6,7})
	dev-python/boto[${PYTHON_USEDEP}]
	dev-python/cfn-lint[${PYTHON_USEDEP}]
	>=dev-python/cryptography-3.3.1[${PYTHON_USEDEP}]
	dev-python/cookies[${PYTHON_USEDEP}]
	>=dev-python/docker-py-2.5.1[${PYTHON_USEDEP}]
	>=dev-python/idna-2.5[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.10.1[${PYTHON_USEDEP}]
	>=dev-python/jsondiff-1.1.2[${PYTHON_USEDEP}]
	>=dev-python/boto3-1.9.201[${PYTHON_USEDEP}]
	>=dev-python/botocore-1.12.201[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-cors[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	dev-python/pretty-yaml[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/python-jose[${PYTHON_USEDEP}]
	dev-python/python-sshpubkeys[${PYTHON_USEDEP}]
	>=dev-python/responses-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.5[${PYTHON_USEDEP}]
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

distutils_enable_tests pytest

python_prepare_all() {
	# unpin indirect dep on ecdsa that's supposed to workaround pip bugs
	sed -i -e '/ecdsa/s:<0.15::' setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		tests/test_firehose/test_firehose_put.py::test_put_record_http_destination
		tests/test_firehose/test_firehose_put.py::test_put_record_batch_http_destination
		tests/test_swf/responses/test_decision_tasks.py::test_respond_decision_task_completed_with_schedule_activity_task_boto3
		tests/test_swf/responses/test_timeouts.py::test_activity_task_heartbeat_timeout_boto3
		tests/test_swf/responses/test_timeouts.py::test_decision_task_start_to_close_timeout_boto3
		tests/test_swf/responses/test_timeouts.py::test_workflow_execution_start_to_close_timeout_boto3
		# Needs network (or docker?) but not marked as such, bug #807031
		# TODO: report upstream
		tests/test_batch/test_batch_jobs.py::test_terminate_job
		tests/test_batch/test_batch_jobs.py::test_cancel_running_job
		tests/test_batch/test_batch_jobs.py::test_dependencies
		tests/test_batch/test_batch_jobs.py::test_container_overrides
		tests/test_sqs/test_integration.py::test_invoke_function_from_sqs_exception
		tests/test_sqs/test_sqs_integration.py::test_invoke_function_from_sqs_exception
	)

	# pytest-django causes freezegun try to mangle stuff inside django
	# which fails when django is not really used
	epytest -p no:django -m 'not network'
}
