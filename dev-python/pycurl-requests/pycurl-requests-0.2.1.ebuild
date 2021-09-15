# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Requests-compatible interface for PycURL"
HOMEPAGE="https://github.com/dcoles/pycurl-requests"
SRC_URI="https://github.com/dcoles/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# network-sandbox
		pycurl_requests/tests/test_requests.py::test_get_connect_timeout
		pycurl_requests/tests/test_requests.py::test_get_connect_timeout_urllib3
	)

	epytest ${deselect[@]/#/--deselect }
}
