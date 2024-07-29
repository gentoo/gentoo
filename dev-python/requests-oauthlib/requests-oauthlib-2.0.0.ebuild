# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="This project provides first-class OAuth library support for Requests"
HOMEPAGE="
	https://github.com/requests/requests-oauthlib/
	https://pypi.org/project/requests-oauthlib/
"
SRC_URI="
	https://github.com/requests/requests-oauthlib/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/oauthlib-3.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/requests-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Internet access
		tests/test_core.py::OAuth1Test::testCanPostBinaryData
		tests/test_core.py::OAuth1Test::test_content_type_override
		tests/test_core.py::OAuth1Test::test_url_is_native_str
	)
	local EPYTEST_IGNORE=(
		tests/examples
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
