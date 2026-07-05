# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Automatically mock your HTTP interactions to simplify and speed up testing"
HOMEPAGE="
	https://github.com/kevin1024/vcrpy/
	https://pypi.org/project/vcrpy/
"
SRC_URI="
	https://github.com/kevin1024/vcrpy/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~x86"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/requests-2.22.0[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/httplib2-0.9.1[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		dev-python/httpx2[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{asyncio,httpbin} )
EPYTEST_RERUNS=5
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# aiohttp incompatibility
		tests/transport/aio/test_aiohttp.py::TestRequest::test_request_clone_with_active_session
		# Internet
		"tests/integration/test_urllib3.py::test_post[https]"
	)

	local EPYTEST_IGNORE=(
		# requires boto3
		tests/integration/test_boto3.py
		# Internet
		tests/integration/test_tornado.py
		tests/integration/test_aiohttp.py
	)

	local -x REQUESTS_CA_BUNDLE=$("${EPYTHON}" -m pytest_httpbin.certs)
	epytest -m 'not online'
}
