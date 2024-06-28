# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

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

PATCHES=(
	# https://github.com/kevin1024/vcrpy/pull/823
	"${FILESDIR}/${P}-httpbin-compat.patch"
)

python_test() {
	local EPYTEST_DESELECT=(
		# these tests are failing with recent dev-python/werkzeug; losely related:
		# https://github.com/kevin1024/vcrpy/issues/645
		tests/integration/test_record_mode.py::test_new_episodes_record_mode_two_times
		tests/integration/test_urllib2.py::test_random_body
		tests/integration/test_urllib2.py::test_multiple_requests
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

	case ${EPYTHON} in
		python3.13)
			EPYTEST_DESELECT+=(
				# SSL problems, might be weak bundle in pytest-httpbin
				# https://github.com/kevin1024/vcrpy/issues/848
				"tests/integration/test_urllib2.py::test_cross_scheme"
				"tests/integration/test_urllib2.py::test_decorator[https]"
				"tests/integration/test_urllib2.py::test_get_data[https]"
				"tests/integration/test_urllib2.py::test_post_data[https]"
				"tests/integration/test_urllib2.py::test_post_decorator[https]"
				"tests/integration/test_urllib2.py::test_post_unicode_data[https]"
				"tests/integration/test_urllib2.py::test_response_code[https]"
				"tests/integration/test_urllib2.py::test_response_headers[https]"
			)
			;;
	esac

	local -x REQUESTS_CA_BUNDLE=$("${EPYTHON}" -m pytest_httpbin.certs)
	epytest -m 'not online'
}
