# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

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
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/httplib2-0.9.1[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/requests-2.16.2[${PYTHON_USEDEP}]
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
		# these tests are failing with recent dev-python/werkzeug; losely related:
		# https://github.com/kevin1024/vcrpy/issues/645
		tests/integration/test_record_mode.py::test_new_episodes_record_mode_two_times
		tests/integration/test_urllib2.py::test_random_body
		tests/integration/test_urllib2.py::test_multiple_requests
		# broken in general
		tests/integration/test_boto.py
		# Internet
		tests/integration/test_tornado.py
		# broken by simplejson, doesn't seem important
		# https://github.com/kevin1024/vcrpy/issues/751
		tests/unit/test_serialize.py::test_serialize_binary_request
	)

	local -x REQUESTS_CA_BUNDLE=$("${EPYTHON}" -m pytest_httpbin.certs)
	epytest -m 'not online'
}
