# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYPI_VERIFY_REPO=https://github.com/python-openapi/openapi-schema-validator
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="OpenAPI schema validation for Python"
HOMEPAGE="
	https://github.com/python-openapi/openapi-schema-validator/
	https://pypi.org/project/openapi-schema-validator/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

RDEPEND="
	<dev-python/jsonschema-5[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.19.1[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-specifications-2024.10.1[${PYTHON_USEDEP}]
	>=dev-python/referencing-0.37.0[${PYTHON_USEDEP}]
	dev-python/rfc3339-validator[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	sed -i -e '/--cov/d' -e 's:\^:>=:' pyproject.toml || die
}
