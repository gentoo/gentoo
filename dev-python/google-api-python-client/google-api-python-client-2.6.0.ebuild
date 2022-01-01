# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Google API Client for Python"
HOMEPAGE="https://github.com/googleapis/google-api-python-client"
SRC_URI="https://github.com/googleapis/google-api-python-client/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-python/httplib2-0.15[${PYTHON_USEDEP}]
	<dev-python/httplib2-1[${PYTHON_USEDEP}]
	dev-python/google-api-core[${PYTHON_USEDEP}]
	>=dev-python/google-auth-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/google-auth-httplib2-0.1.0[${PYTHON_USEDEP}]
	>=dev-python/uritemplate-3.0.0[${PYTHON_USEDEP}]
	<dev-python/uritemplate-4[${PYTHON_USEDEP}]
	>=dev-python/six-1.13.0[${PYTHON_USEDEP}]
	<dev-python/six-2[${PYTHON_USEDEP}]
	"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/oauth2client[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
	)"

distutils_enable_tests --install pytest

python_test() {
	local deselect=(
		# require Internet access (and credentials)
		tests/test_discovery.py::DiscoveryErrors::test_credentials_and_credentials_file_mutually_exclusive
		tests/test_discovery.py::DiscoveryFromDocument::test_api_endpoint_override_from_client_options_mapping_object
	)

	distutils_install_for_testing
	epytest ${deselect[@]/#/--deselect }
}
