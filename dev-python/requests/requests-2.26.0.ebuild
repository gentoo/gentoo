# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="HTTP library for human beings"
HOMEPAGE="https://requests.readthedocs.io/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="socks5"

RDEPEND="
	>=dev-python/certifi-2017.4.17[${PYTHON_USEDEP}]
	dev-python/charset_normalizer[${PYTHON_USEDEP}]
	<dev-python/idna-4[${PYTHON_USEDEP}]
	<dev-python/urllib3-1.27[${PYTHON_USEDEP}]
	socks5? ( >=dev-python/PySocks-1.5.6[${PYTHON_USEDEP}] )
"

BDEPEND="
	test? (
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
		>=dev-python/PySocks-1.5.6[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-test.patch
)

python_test() {
	local deselect=(
		# Internet
		requests/__init__.py::requests
		requests/api.py::requests.api.request
		requests/models.py::requests.models.PreparedRequest
		requests/sessions.py::requests.sessions.Session
		tests/test_requests.py::TestRequests::test_https_warnings
		tests/test_requests.py::TestTimeout::test_connect_timeout
		tests/test_requests.py::TestTimeout::test_total_timeout_connect
		# TODO: openssl?
		tests/test_requests.py::TestRequests::test_pyopenssl_redirect
	)

	epytest ${deselect[@]/#/--deselect }
}
