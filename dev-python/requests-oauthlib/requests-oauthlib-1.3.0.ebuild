# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="This project provides first-class OAuth library support for Requests"
HOMEPAGE="https://github.com/requests/requests-oauthlib"
SRC_URI="https://github.com/requests/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="ISC"
KEYWORDS="amd64 ~arm x86"

RDEPEND="
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/oauthlib-3.0.0[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/requests-mock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# Internet access
		tests/test_core.py::OAuth1Test::testCanPostBinaryData
		tests/test_core.py::OAuth1Test::test_content_type_override
		tests/test_core.py::OAuth1Test::test_url_is_native_str
	)

	epytest ${deselect[@]/#/--deselect }
}
