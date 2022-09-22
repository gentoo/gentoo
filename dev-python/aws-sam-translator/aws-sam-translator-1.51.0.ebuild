# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="A library that transform SAM templates into AWS CloudFormation templates"
HOMEPAGE="
	https://github.com/aws/serverless-application-model/
	https://pypi.org/project/aws-sam-translator/
"
SRC_URI="
	https://github.com/aws/serverless-application-model/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/serverless-application-model-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	<dev-python/boto3-2[${PYTHON_USEDEP}]
	>=dev-python/boto3-1.19.5[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.2[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	tests/validator/test_validator_api.py::TestValidatorApi::test_errors_13_error_definitionuri
	tests/unit/test_region_configuration.py::TestRegionConfiguration::test_is_service_supported_positive_4_ec2
	tests/plugins/application/test_serverless_app_plugin.py::TestServerlessAppPlugin_on_before_transform_template_translate::test_sar_success_one_app
	tests/plugins/application/test_serverless_app_plugin.py::TestServerlessAppPlugin_on_before_transform_template_translate::test_sar_throttling_doesnt_stop_processing
	tests/plugins/application/test_serverless_app_plugin.py::TestServerlessAppPlugin_on_before_transform_template_translate::test_sleep_between_sar_checks
	tests/plugins/application/test_serverless_app_plugin.py::TestServerlessAppPlugin_on_before_transform_template_translate::test_unexpected_sar_error_stops_processing
	tests/plugins/application/test_serverless_app_plugin.py::TestServerlessAppPlugin_on_before_and_on_after_transform_template::test_time_limit_exceeds_between_combined_sar_calls
)

python_prepare_all() {
	# remove pytest-cov dependency
	sed -i -e '/addopts/d' pytest.ini || die

	# deps are installed by ebuild, don't try to reinstall them via pip
	truncate --size=0 requirements/*.txt || die

	distutils-r1_python_prepare_all
}
