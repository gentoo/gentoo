# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Automatically mock your HTTP interactions to simplify and speed up testing"
HOMEPAGE="
	https://github.com/kevin1024/vcrpy/
	https://pypi.org/project/vcrpy/
"
SRC_URI="
	https://github.com/kevin1024/vcrpy/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	>=dev-python/httplib2-0.9.1[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/six-1.5[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	dev-python/yarl[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# these tests require Internet
		tests/integration/test_aiohttp.py
		tests/integration/test_boto.py
		tests/integration/test_httpx.py
		tests/integration/test_wild.py::test_flickr_should_respond_with_200
		tests/integration/test_wild.py::test_amazon_doctype
		tests/unit/test_stubs.py::TestVCRConnection::testing_connect

		# probably unhappy about ssl module being more strict now
		'tests/integration/test_httplib2.py::test_effective_url[https]'
		'tests/integration/test_requests.py::test_effective_url[https]'
		'tests/integration/test_requests.py::test_redirects[https]'
		'tests/integration/test_urllib2.py::test_effective_url[https]'
		'tests/integration/test_urllib3.py::test_redirects[https]'
	)

	local -x REQUESTS_CA_BUNDLE=$("${EPYTHON}" -m pytest_httpbin.certs)
	epytest
}
