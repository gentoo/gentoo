# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_VERIFY_REPO=https://github.com/marshmallow-code/apispec
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="A pluggable API specification generator"
HOMEPAGE="
	https://github.com/marshmallow-code/apispec/
	https://pypi.org/project/apispec/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

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

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx-issues \
	dev-python/sphinx-rtd-theme

EPYTEST_DESELECT=(
	# requires unpackaged prance
	tests/test_ext_marshmallow_openapi.py::test_openapi_tools_validate_v2
	tests/test_ext_marshmallow_openapi.py::test_openapi_tools_validate_v3
)
