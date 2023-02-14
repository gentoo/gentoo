# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A pluggable API specification generator"
HOMEPAGE="
	https://github.com/marshmallow-code/apispec/
	https://pypi.org/project/apispec/
"
SRC_URI="
	https://github.com/marshmallow-code/apispec/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/bottle[${PYTHON_USEDEP}]
		>=dev-python/marshmallow-3.18.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx-issues \
	dev-python/sphinx-rtd-theme

python_test() {
	local EPYTEST_DESELECT=(
		# requires unpackaged prance
		tests/test_ext_marshmallow_openapi.py::test_openapi_tools_validate_v2
		tests/test_ext_marshmallow_openapi.py::test_openapi_tools_validate_v3
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
