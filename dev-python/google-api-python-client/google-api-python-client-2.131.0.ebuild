# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Google API Client for Python"
HOMEPAGE="
	https://github.com/googleapis/google-api-python-client/
	https://pypi.org/project/google-api-python-client/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/httplib2-0.15[${PYTHON_USEDEP}]
	<dev-python/httplib2-1[${PYTHON_USEDEP}]
	>=dev-python/google-api-core-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/google-auth-1.35.0[${PYTHON_USEDEP}]
	>=dev-python/google-auth-httplib2-0.1.0[${PYTHON_USEDEP}]
	>=dev-python/uritemplate-3.0.0[${PYTHON_USEDEP}]
	<dev-python/uritemplate-5[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# require Internet access (and credentials)
		tests/test_discovery.py::DiscoveryErrors::test_credentials_and_credentials_file_mutually_exclusive
		tests/test_discovery.py::DiscoveryFromDocument::test_api_endpoint_override_from_client_options_mapping_object
		tests/test_discovery.py::Universe::test_client_options_universe_configured_with_mtls
		tests/test_discovery.py::Universe::test_universe_env_var_configured_with_mtls
	)

	epytest tests
}
